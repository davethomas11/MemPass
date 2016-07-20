package com.daveanthonythomas.klibmempass

import java.nio.charset.Charset
import java.security.MessageDigest
import java.util.*

/**
 * Created by dave on 2016-07-19.
 */

class MemPass(mDice: Dice) {

    var mOptions = Options()
    private var seed: String = ""

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
}