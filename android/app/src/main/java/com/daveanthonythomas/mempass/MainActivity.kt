package com.daveanthonythomas.mempass

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import com.daveanthonythomas.klibmempass.MemPass
import com.daveanthonythomas.mempass.database.WordDB
import org.jetbrains.anko.*

class MainActivity : AppCompatActivity() {

    var mMemPass:MemPass? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        mMemPass = MemPass(WordDB.getInstance(this))

        MainActivityUI().setContentView(this)
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        menuInflater.inflate(R.menu.menu_mem_pass, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem?): Boolean {

        if (item?.itemId == R.id.action_settings) {
            return true
        }

        return super.onOptionsItemSelected(item)
    }

    fun processMemPass(input: String) {

        System.out.println(input)
    }
}
