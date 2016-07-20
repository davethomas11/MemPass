package com.daveanthonythomas.klibmempass

/**
 * Created by dave on 2016-07-19.
 *
 * Options used by MemPass
 */
class Options {
    val SPECIAL_CHAR_MOD = 7
    val CAPITAL_LETTER_MOD = 7
    val DICE_MOD = 4
    val NUMBER_REPLACE = "n"
    val DEFAULT_UPPERCASE = "A"
    val DICE_OFFSET = 100000
    val DICE_LEFT_BRACE = "-> "
    val DICE_RIGHT_BRACE = " <-"

    var mApplyLimitBeforeDice = false
    var mHasNumber = true
    var mHasCapital = true
    var mHasDiceWords = true
    var mCharacterLimit = 0
    var mSpecialChars = arrayOf("!", "@", "#", "$", "%", "^", "`", "~", "&", "*", "(", "=", "_", "{", "+", "}")

    /**
     * Reset to the global default settings for MemPass
     * These should always be the same values for our defaults
     */
    fun setToDefaults() {
        mApplyLimitBeforeDice = false
        mHasNumber = true
        mHasCapital = true
        mHasDiceWords = true
        mCharacterLimit = 0
        mSpecialChars = arrayOf("!", "@", "#", "$", "%", "^", "`", "~", "&", "*", "(", "=", "_", "{", "+", "}")
    }

    /**
     * @return the special characters array as a concatenated string
     */
    fun getSpecialCharString(): String {

        return mSpecialChars.reduce { a, b -> a + b }
    }

    /**
     * Split the [value] into an array of characters and set them on this option object's
     * specialChars value
     */
    fun setSpecialCharString(value: String?) {

        value?.let { value ->

            mSpecialChars = arrayOf<String>()

            for (character in value.toCharArray())
                mSpecialChars.plus(character.toString())
        }
    }

    /**
     * This settings string value is used when scanning or setting a seed
     * it is concatenated on the end of the seed to make up the QR code
     * or string value code a user can use to set MemPass to
     * generate the same passwords in another application
     *
     * @return The transportable string representation of these settings
     */
    fun settingsString(): String {

        val builder = StringBuilder()
        builder.append(if (mApplyLimitBeforeDice) 1 else 0)
        builder.append(".")
        builder.append(if (mHasNumber) 1 else 0)
        builder.append(".")
        builder.append(if (mHasCapital) 1 else 0)
        builder.append(".")
        builder.append(if (mHasDiceWords) 1 else 0)
        builder.append(".")
        builder.append("${mCharacterLimit}.")

        if (mSpecialChars.size > 0) {
            builder.append(getSpecialCharString())
        }

        return builder.toString()
    }

    /**
     * Parse the [settings] value into a member values for this instance
     */
    fun parseSettingsString(settings: String) {

        val parts = settings.split(".")

        if (parts.size >= 5) {

            mApplyLimitBeforeDice = parts[0] == "1"
            mHasNumber = parts[1] == "1"
            mHasCapital = parts[2] == "1"
            mHasDiceWords = parts[3] == "1"
            mCharacterLimit = try {
                Integer.parseInt(parts[4])
            } catch (e:NumberFormatException) {
                0
            }


            val specialChars = settings.replace(Regex("^([0-9]+.){5}"), "")
            setSpecialCharString(specialChars)

        }
    }

}