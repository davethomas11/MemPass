package com.daveanthonythomas.mempass.database

import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

import com.daveanthonythomas.klibmempass.Dice

import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream

/**
 * Created by dave on 2016-07-22.
 */

class WordDB private constructor(context: Context) : SQLiteOpenHelper(context, WordDB.DB_NAME, null, WordDB.VERSION), Dice {
    private var copyFailed = false

    override fun wordCount(): Int {
        val db = readableDatabase
        val c = db.rawQuery("select count(*) as size from words", null)
        c.moveToFirst()
        return c.getInt(c.getColumnIndex("size"))
    }

    override fun wordAt(index: Int): String {
        val db = readableDatabase
        val c = db.rawQuery("select word from words where id = ?", arrayOf("" + index))
        if (c.moveToFirst()) {
            return c.getString(c.getColumnIndex("word"))
        } else {
            return ""
        }
    }

    override fun onCreate(db: SQLiteDatabase) {
        if (copyFailed) {
            db.execSQL("CREATE TABLE words (id INTEGER PRIMARY KEY, word TEXT)")
        }
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {

    }

    companion object {

        //The Android's default system path of your application database.
        private val DB_PATH = "/data/data/com.daveanthonythomas.mempass/databases/"
        private val DB_NAME = "words.sqlite3"

        private val VERSION = 1

        private var instance: WordDB? = null

        fun getInstance(context: Context): WordDB? {

            if (instance == null) {
                instance = WordDB(context)
            }

            if (!checkDataBase()) {
                try {
                    copyDataBase(context)
                } catch (e: Exception) {

                    instance!!.copyFailed = true
                }

            }

            return instance
        }

        /**
         * Check if the database already exist to avoid re-copying the file each time you open the
         * application.

         * @return true if it exists, false if it doesn't
         */
        private fun checkDataBase(): Boolean {

            val file = File(DB_PATH + DB_NAME)
            return file.exists()
        }

        /**
         * Copies your database from your local assets-folder to the just created empty database in the
         * system folder, from where it can be accessed and handled.
         * This is done by transfering bytestream.
         */
        @Throws(IOException::class)
        private fun copyDataBase(context: Context) {

            //Open your local db as the input stream
            val myInput = context.assets.open(DB_NAME)

            // Path to the just created empty db
            val outFileName = DB_PATH + DB_NAME

            //Open the empty db as the output stream
            val myOutput = FileOutputStream(outFileName)

            //transfer bytes from the inputfile to the outputfile
            val buffer = ByteArray(1024)
            var length: Int = myInput.read(buffer)
            while (length > 0) {
                myOutput.write(buffer, 0, length)
                length = myInput.read(buffer)
            }

            //Close the streams
            myOutput.flush()
            myOutput.close()
            myInput.close()

        }
    }
}
