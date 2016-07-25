package com.daveanthonythomas.klibmempass

import java.nio.charset.Charset
import java.security.MessageDigest
import java.util.*
import kotlin.comparisons.compareBy

/**
 * Created by dave on 2016-07-19.
 */

class MemPass(dice: Dice?) {

    var mDice = dice
    var mOptions = Options()
    private var seed: String = ""
    private var phrase: String = ""

    /**
     * ReSeeds with auto generated seed or passed in seed
     * passed in seed can contain | pipe character to split
     * seed and options string for MemPass Options
     *
     * @return new seed value
     */
    fun reSeed(newSeed: String? = null): String {

        if (newSeed != null) {

            if (newSeed.contains("\\|")) {

                seed = parseSeedForOptions(newSeed)
            } else {

                seed = newSeed
            }
        } else {

            seed = newSeed()
        }

        return seed
    }

    /**
     * Generate a new seed value
     */
    fun newSeed(): String {
        val now = Date()
        val uuid = UUID.randomUUID().toString()
        val seedsSeed = "$now-$uuid"
        val bytes = seedsSeed.toByteArray(Charset.forName("UTF-8"))

        val messageDigest = MessageDigest.getInstance("SHA-256")
        messageDigest.update(bytes)

        val result = messageDigest.digest()

        return String.format("%064x", java.math.BigInteger(1, result))
    }

    /**
     * @return currently set seed value
     */
    fun getSeed(): String {
        return seed
    }

    /**
     * Parse the options string on the end of a seed value
     *
     * @return the seed value with the options string stripped off the end
     */
    fun parseSeedForOptions(newSeed: String): String {
        val parts = newSeed.split("\\|")

        if (parts.size > 1) {

            var optsString = newSeed.replace("${parts[0]}|", "")
            mOptions.parseSettingsString(optsString)
        }

        return parts[0]
    }

    /**
     * Apply special character replacement
     *
     * 1. Sort the occurrences of each character in the input string
     *    by the character with the most occurrences
     *    Tie break with characters alphabetically
     *
     * 2. Loop until either all special characters are exhausted or
     *    unique occurrences of characters are replaced
     *
     *     Doing:
     *       - replace first occurrence with first special character from
     *       list. Replace all occurrences if the current iteration
     *       modulo the SPECIAL_CHAR_MOD has a remainder otherwise
     *       replace just the first occurrence of the character
     *
     *
     */
    fun specialCharPass(input: String): String {

        var occurrences = HashMap<Char, Int>()
        var output = "$input"

        for (character in input.toCharArray()) {

            var count = occurrences.get(character) ?: 0
            occurrences.put(character, count + 1)
        }

        var index = 0
        var sortedKeys = occurrences.keys.sortedWith(
                compareBy({
                    it
                }, {
                    occurrences.get(it)
                })
        ).toMutableList()

        var specialChars = mOptions.mSpecialChars.toMutableList()

        while (specialChars.size > 0 && sortedKeys.size > 0) {

            val character = sortedKeys.get(0)
            val value = character!!.toInt()
            var specialCharIndex = value % specialChars.size

            if (specialCharIndex >= specialChars.size || specialCharIndex < 0) {
                specialCharIndex = 0
            }
            val specialChar = specialChars.get(specialCharIndex).toCharArray().get(0)

            if (index % mOptions.SPECIAL_CHAR_MOD == 0) {

                output = output.replace(character, specialChar, false)

            } else {

                output = output.replaceFirst(character, specialChar, false)
            }

            index += 1

            sortedKeys.remove(character)
            specialChars.removeAt(0)
        }

        return output
    }

    /**
     * Ensures there is 1 capital and 1 lower case in the string
     */
    fun capitalLetterPass(input: String): String {

        val target = (passwordSum(input) % mOptions.CAPITAL_LETTER_MOD) + 2
        var found = 0

        var output = "${input}"
        var hasUpperCase = false
        var hasLowerCase = false

        for (character in input.toCharArray()) {

            if (character.isLetter()) {

                if (found % 2 == 0) {

                    output.replaceFirst(character, character.toUpperCase(), false)
                    hasUpperCase = true
                } else {

                    output.replaceFirst(character, character.toLowerCase(), false)
                    hasLowerCase = true
                }

                found += 1

                if (target == found) {
                    break;
                }
            }

        }

        if (!hasUpperCase) {
            output += mOptions.DEFAULT_UPPERCASE
        }

        if (!hasLowerCase) {
            output += mOptions.NUMBER_REPLACE
        }

        return output
    }

    /**
     * Remove any numbers from MemPass string
     * @return cleaned string
     */
    fun removeNumberPass(input: String): String {
        return input.replace(Regex("[0-9]"), mOptions.NUMBER_REPLACE)
    }

    /**
     * Adds dice words through out the MemPass string
     */
    fun diceWordPass(input: String): String {

        val wordCount = mDice?.wordCount() ?: 0
        val sum = passwordSum(input)
        var characterCount = input.length - 1
        var offset = mOptions.DICE_OFFSET
        val target = (sum % mOptions.DICE_MOD) - 1
        var parts = ArrayList<String>()
        var tmp = "$input"

        for (i in 1..target) {
            if (characterCount <= 0) {
                break;
            }

            val position = sum % characterCount
            var wordX = (sum * offset) % wordCount

            if (wordX <= 0 || wordX >= wordCount) {
                wordX = 1
            }

            parts.add(tmp.substring(0, position))
            tmp = tmp.replaceFirst(tmp.substring(0, position), "")

            mDice?.wordAt(i).let {
                if (mOptions.mSpecialChars.size > 0) {
                    parts.add(mOptions.DICE_LEFT_BRACE + it + mOptions.DICE_RIGHT_BRACE)
                } else {
                    parts.add(it!!)
                }
            }

            characterCount = tmp.length

            offset -= 1
        }

        return parts.reduce { a, b -> a + b }
    }


    /**
     * @return the string setup in the following manner:
     *
     * [input]-[input.reversed]-|[seed].)
     *
     */
    fun getInitialValue(input : String): String {
        return "$input-${input.reversed()}-|$seed.)"
    }

    /**
     * @return a SHA256 hash of the string passed to initial value
     */
    fun getInitialHash(input : String): String {
        val bytes = getInitialValue(input).toByteArray(Charset.forName("UTF-8"))

        val messageDigest = MessageDigest.getInstance("SHA-256")
        messageDigest.update(bytes)

        val result = messageDigest.digest()

        return String.format("%064x", java.math.BigInteger(1, result))
    }

    /**
     * @return the input string limited if there is a limit in options
     */
    fun limit(input: String): String {
        if (mOptions.mCharacterLimit > 0 && input.length > mOptions.mCharacterLimit) {
            return input.substring(0, mOptions.mCharacterLimit)
        } else {
            return input
        }
    }

    /**
     * @return key for syncing your MemPass with another application
     */
    fun memPassSyncKey(): String {
        return "$seed|${mOptions.settingsString()}"
    }

    /**
     * @return the sum of all the character code values
     */
    fun passwordSum(input: String): Int {

        var sum = 0
        for (character in input.toCharArray()) {
            sum += character.toInt()
        }
        return sum
    }

    /**
     * Applies MemPass algorithm based on options set
     *
     * @return a MemPass generated password
     */
    fun generate(input: String): String {

        phrase = input
        var output = "$input"

        val hash = getInitialHash(phrase)

        if (mOptions.mSpecialChars.size > 0) {

            output = specialCharPass(output)
        }

        if (mOptions.mApplyLimitBeforeDice) {

            output = limit(output)
        }

        if (mOptions.mHasDiceWords) {

            output = diceWordPass(output)
        }

        if (!mOptions.mHasNumber) {

            output = removeNumberPass(output)
        }

        if (!mOptions.mApplyLimitBeforeDice) {

            output = limit(output)
        }

        if (!mOptions.mHasCapital) {

            output = output.toLowerCase()
        } else {

            output = capitalLetterPass(output)
        }

        return output
    }
}