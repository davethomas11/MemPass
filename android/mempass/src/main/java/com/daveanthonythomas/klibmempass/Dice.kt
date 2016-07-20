package com.daveanthonythomas.klibmempass

/**
 * Created by dave on 2016-07-19.
 */
interface Dice {

    /**
     * @return the number of possible dice words
     */
    fun wordCount():Int

    /**
     * @return the word in dice collection at [index]
     */
    fun wordAt(index:Int):String
}