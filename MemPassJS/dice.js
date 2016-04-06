function MemPassDice(injection) {

    if (!inNode && typeof XMLHttpRequest != 'undefined' && (!chrome || !chrome.storage)) {
        loadWordJSON();
    }

    var staticLoadedJSON = null;

	var dbName = "Words";
	var dbVersion = 1;
	
	var objectStore = "words";
	var indexKey = "wordId";
	var sqlLiteDb = "words.sqlite3";
	var sqlite3 = false;

	if (inNode && injection) {
		
		sqlite3 = injection.sqlite3;
		sqlLiteDb = injection.sqlite3Path;
	}

	this.getWordCount = function(callback) {

		if (isChrome && chrome.storage) {

			chrome.storage.local.get("mempassDatabaseInstalled", function (items) {
				if (items.mempassDatabaseInstalled) {
					chromeWordCount(callback);
				} else {
					staticWordCount(callback);
				}
			});
			

		} else if (inNode) {

			var fs = require('fs'); 

			fs.stat(sqlLiteDb, function (err, stat) {

				if (err) {

					nodeStaticWordCount(callback);
					
				} else {
				
					nodeWordCount(callback);
				}
			});

		} else {

			staticWordCount(callback);
		}
	};

	this.wordAt = function(index, callback) {

		if (isChrome && chrome.storage) {

			chrome.storage.local.get("mempassDatabaseInstalled", function (items) {
				if (items.mempassDatabaseInstalled) {
					chromeGetWordAt(index, callback);
				} else {
					staticGetWordAt(index, callback);
				}
			});
			
		} else if (inNode) {

			var fs = require('fs'); 

			fs.stat(sqlLiteDb, function (err, stat) {

				if (err) {

					nodeStaticGetWordAt(index, callback);
				} else {

					nodeWordAt(index, callback);
				}
			});	
			
		} else {

			staticGetWordAt(index, callback);
		}
	};

	this.nodeSqlLite3Install = function(filename, callback) {

		db = new sqlite3.Database(sqlLiteDb);
		db.serialize(function () {
			db.run("DROP TABLE IF EXISTS words");
			db.run("CREATE TABLE IF NOT EXISTS words (id INTEGER, word TEXT)");

			var stmt = db.prepare("INSERT INTO words (id, word) VALUES (?,?)");

			var data = require(filename);
			var index = 1;

			for (i in data) {

				stmt.run(data[i].id, data[i].word);

				var progress = (index / data.length) * 100;

				if (index > 1) {
					process.stdout.clearLine();
  					process.stdout.cursorTo(0);
  				}
				process.stdout.write('Progress: '+progress+'% | '+index+' of '+data.length+' words done.');

				index++;
			}

			console.log("Finalizing...");
			stmt.finalize(callback);
		});
		db.close();
	};

	function nodeWordAt(index, callback) {

		db = new sqlite3.Database(sqlLiteDb);
		db.serialize(function () {

			db.get("SELECT word FROM words WHERE id = ?", index, function (err, row) {

				if (err) {

					console.log(err);
					callback("");
				
				} else {

					callback(row.word);
				}
			});
		});
		db.close();
	}

	function nodeWordCount(callback) {

		db = new sqlite3.Database(sqlLiteDb);
		db.serialize(function () {

			db.get("SELECT COUNT(*) AS wordCount FROM words", function (err, row) {

				if (err) {

					console.log(err);
					callback(0);
				} else {

					callback(row.wordCount);
				}
			});
		})
	}

	function nodeStaticWordCount(callback) {

        var data = null;
        if (!staticLoadedJSON) {
            data = require(injection.wordJSONPath);
            staticLoadedJSON = data;
        } else {
            data = staticLoadedJSON;
        }

		if (data) {
			callback(data.length);
		} else {
			callback(0);
		}
		
	}

	function nodeStaticGetWordAt(index, callback) {

        var data = null;
        if (!staticLoadedJSON) {
            data = require(injection.wordJSONPath);
            staticLoadedJSON = data;
        } else {
            data = staticLoadedJSON;
        }

		if (data) {
			var i = index - 1;
			if (i >= 0 && i < data.length) {
				callback(data[i].word);
			} else {
				console.log("Word index out of bounds: " + i);
				callback("");
			}
		} else {
			callback("");
		}
	}

	function staticWordCount(callback) {

        if (staticLoadedJSON) {
            callback(staticLoadedJSON.length);
            return;
        }

		var xhr = new XMLHttpRequest();
		xhr.onload = function (event) {

			var data = JSON.parse(event.target.response);
            staticLoadedJSON = data;
			callback(data.length);
		};

		xhr.onerror = function (event) {
			console.log(event.error);
			callback(0);
		};

		xhr.type = "json";

		if (chrome && chrome.extension) {
			xhr.open("GET", chrome.extension.getURL('/word.json'), true);
		} else {
			xhr.open("GET", 'js/word.json', true);
		}

		xhr.send();
	}

	function staticGetWordAt(index, callback) {

        if (staticLoadedJSON) {
            var i = index - 1;
            if (i < 0 || i >= staticLoadedJSON.length) {
                console.log("Word index out of bounds: " + i);
                callback("");
            } else {
                callback(staticLoadedJSON[i].word);
            }
            return;
        }

		var xhr = new XMLHttpRequest();
		xhr.onload = function(event) {
					
			var data = JSON.parse(event.target.response);
            staticLoadedJSON = data;
			var i = index - 1;

			if (i >= 0 && i < data.length) {
				callback(data[i].word);
			} else {
				console.log("Word index out of bounds: " + i);
				callback("");
			}
		};

		xhr.onerror = function(event) {
			console.log(event.error);
			callback("");
		};

		xhr.type="json";

		if (chrome && chrome.extension) {
			xhr.open("GET", chrome.extension.getURL('/word.json'), true);
		} else {
			xhr.open("GET", 'js/word.json', true);
		}

		xhr.send();
	}

    function loadWordJSON() {
        var xhr = new XMLHttpRequest();
        xhr.onload = function(event) {

            staticLoadedJSON = JSON.parse(event.target.response);
        };

        xhr.onerror = function(event) {
            console.log(event.error);
        };

        xhr.type="json";

        if (chrome && chrome.extension) {
            xhr.open("GET", chrome.extension.getURL('/word.json'), true);
        } else {
            xhr.open("GET", 'js/word.json', true);
        }

        xhr.send();
    }

	this.chromeInstall = function(callback, eventStatus) {

		openIndexedDB(function (err, connection) {

			if (err) {
				
				console.log(err);
				if (callback) {
					callback(err, false);
				}

			} else {

				var xhr = new XMLHttpRequest();
				xhr.onload = function(event) {
					
					var data = JSON.parse(event.target.response);
					var len = data.length;

					function transaction(i) {

						if (i == data.length) {
							installComplete();
							return;
						}

						var trans = connection.transaction(objectStore, "readwrite");
						var store = trans.objectStore(objectStore);

						var word = data[i].word;
						var id = data[i].id;

						var item = {word:word, id:id};
						var storeReq = store.add(item);

						
						storeReq.onsuccess = function (event) {
							if (eventStatus) {
								eventStatus(item, id / len);
							}

							transaction(++i);
						}

						storeReq.onerror = function (event) {

							console.log(event.target.error);
							callback(event.target.error, null);
						}
					}
					
					transaction(0);

					function installComplete() {

						connection.close();

						if (callback) {
							callback(null, true);
						}
					}
				}
			
				xhr.type="json";
				xhr.open("GET", chrome.extension.getURL('/word.json'), true);
				
				xhr.send();

			}


		});

	}

	function chromeWordCount(callback) {

		openIndexedDB(function (err, connection) {

			if (err) {
				
				console.log(err);
				callback(0);
			} else {

				var transaction = connection.transaction(objectStore, "readonly");
				var words = transaction.objectStore(objectStore);
				var index = words.index(indexKey);
				
				var req = index.count();

				req.onsuccess = function () {
					callback(req.result);
					connection.close();
				};

				req.onerror = function () {
					console.log(req.error);
					callback(0);
					connection.close();
				};
				

			}
 		});
	}

	function chromeGetWordAt(id, callback) {

		openIndexedDB(function (err, connection) {

			if (err) {
				
				console.log(err);
				callback("");

			} else {

				var trans = connection.transaction(objectStore, "readonly");
				var words = trans.objectStore(objectStore);
				var index = words.index(indexKey);
				
				var req = index.get(id);
				
				req.onsuccess = function () {

					callback(req.result.word);
					connection.close();
				};

				req.onerror = function () {
					
					callback("");
					connection.close();
				};

			}
		});

	}

	function openIndexedDB(callback) {

		var req = indexedDB.open(dbName, dbVersion);

		req.onupgradeneeded = function(event) {
			var db = event.target.result;

			if (!db.objectStoreNames.contains(objectStore)) {
				var store = db.createObjectStore(objectStore, { keyPath: "id"});
				store.createIndex(indexKey, "id", {unique:true});

			} 

		}

		req.onsuccess = function() {

			callback(null, req.result);
		}

		req.onerror = function() {

			console.log(req.error);

			req.closePending = true;
			callback(req.error, null);
		}
	}

}

