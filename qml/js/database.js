.pragma library

.import QtQuick.LocalStorage 2.0 as Sql

var initialized = false;
var dbName = "Slideshow";
var dbVer = "1.0";
var dbDescr = "Slideshow -database.";
var dbSize = 1000000;

// ----------------------------------------------------------
// Database handling.

// Initializes the database.
function initializeDatabase()
{
    console.log("Initializing database...")
    var db = Sql.LocalStorage.openDatabaseSync(dbName, dbVer, dbDescr, dbSize);
    db.transaction(
                function(tx) {
                    // Create Slideshow-table if it doesn't already exist.
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Slideshow(name TEXT)');

                    // Create Music-table if it doesn't already exist.
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Music(fileName TEXT, fileUrl TEXT, slideshowId INT NOT NULL, FOREIGN KEY (slideshowId) REFERENCES Slideshow (rowid) ON DELETE CASCADE ON UPDATE NO ACTION)');

                    // Create Image-table if it doesn't already exist.
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Image(fileName TEXT, fileUrl TEXT, slideshowId INT NOT NULL, FOREIGN KEY (slideshowId) REFERENCES Slideshow (rowid) ON DELETE CASCADE ON UPDATE NO ACTION)');
                }
                )
    console.log("Database initialized...")
    initialized = true
}

// Returns the database or false if database is not initialized and for some reason initializing does not work.
function getDatabase()
{
    console.log("Getting database...")
    // Check if the database is initialized or not.
    if(!initialized)
    {
        console.log("Database not initialized...")
        initializeDatabase()

        if(initialized)
        {
            var db = Sql.LocalStorage.openDatabaseSync(dbName, dbVer, dbDescr, dbSize);
            return db
        }
        else
            return false
    }
    else // Database initialized.
    {
        var dab = Sql.LocalStorage.openDatabaseSync(dbName, dbVer, dbDescr, dbSize);
        return dab
    }
}

function getSlideshowNames() {
    var db = getDatabase();
    var slideshows;

    if(db) {
        db.transaction(function(tx) {
            var res = tx.executeSql('SELECT rowid as id, name FROM Slideshow ORDER BY rowid');
            slideshows = res.rows;
        });
    }

    return slideshows;
}

function getSlideshow(slideshowId) {
    var db = getDatabase();
    var slideshow = {'id': slideshowId, 'name': '', 'music': [], 'images': []}

    if(db) {
        db.transaction(function(tx) {
            var res = tx.executeSql('SELECT name FROM Slideshow WHERE rowid=?', [slideshowId]);
            if (res.rows.length === 1) {
                slideshow.name = res.rows[0].name;

                var musics = tx.executeSql('SELECT rowid, fileName, fileUrl FROM Music WHERE slideshowId=?', [slideshowId]);
                if (musics.rows.length > 0) {
                    for (var i = 0; i < musics.rows.length; ++i) {
                        var music = musics.rows[i];
                        slideshow.music.push({'fileName': music.fileName, 'url': music.fileUrl})
                    }
                }

                var pics = tx.executeSql('SELECT rowid, fileName, fileUrl FROM Image WHERE slideshowId=?', [slideshowId]);
                if (pics.rows.length > 0) {
                    for (var j = 0; j < pics.rows.length; ++j) {
                        var pic = pics.rows[j];
                        slideshow.images.push({'fileName': pic.fileName, 'url': pic.fileUrl})
                    }
                }
            } else if (res.rows.length === 0 || res.rows.length > 1) {
                return null;
            }
        });
    }

    return slideshow;
}

function writeSlideshow(slideshow) {
    var db = getDatabase();
    var slideId = -1;
    if(db) {
        db.transaction(function(tx) {
            var res = tx.executeSql('INSERT INTO Slideshow VALUES(?)', [slideshow.name]);
            var id = parseInt(res.insertId);
            if(id !== NaN) {
                slideId = id;

                // Add music
                if (slideshow.music && slideshow.music.length > 0) {
                    for (var i = 0; i < slideshow.music.length; ++i) {
                        var mus = slideshow.music[i]
                        var resM = tx.executeSql('INSERT INTO Music VALUES(?, ?, ?)', [mus.fileName, mus.url, id]);
                    }
                }

                // Add images
                if (slideshow.images && slideshow.images.length > 0) {
                    for (var j = 0; j < slideshow.images.length; ++j) {
                        var img = slideshow.images[j]
                        var resI = tx.executeSql('INSERT INTO Image VALUES(?, ?, ?)', [img.fileName, img.url, id]);
                    }
                }
            }
        });
    }

    return slideId;
}

function updateSlideshow(slideshow) {
    var db = getDatabase();
    if (db) {
        db.transaction(function(tx) {
            var res = tx.executeSql('UPDATE Slideshow SET name=? WHERE rowid=?', [slideshow.name, slideshow.id]);
            if (res.rowsAffected !== 1) {
                return false;
            }

            var del1 = tx.executeSql('DELETE FROM Music WHERE slideshowId=?', [slideshow.id]);
            var del2 = tx.executeSql('DELETE FROM Image WHERE slideshowId=?', [slideshow.id]);

            // Add music
            if (slideshow.music && slideshow.music.length > 0) {
                for (var i = 0; i < slideshow.music.length; ++i) {
                    var mus = slideshow.music[i]
                    var resM = tx.executeSql('INSERT INTO Music VALUES(?, ?, ?)', [mus.fileName, mus.url, slideshow.id]);
                }
            }

            // Add images
            if (slideshow.images && slideshow.images.length > 0) {
                for (var j = 0; j < slideshow.images.length; ++j) {
                    var img = slideshow.images[j]
                    var resI = tx.executeSql('INSERT INTO Image VALUES(?, ?, ?)', [img.fileName, img.url, slideshow.id]);
                }
            }
        });
    }

    return true;
}
