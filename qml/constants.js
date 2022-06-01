.pragma library

var languageKey = "language";
var intervalKey = "interval";
var loopKey = "loop";
var randomKey = "random";
var stopMinimizedKey = "stopMinimized";
var loopMusicKey = "loopBackgroundMusic";
var selectFolderFromRootKey = "selectFolderFromRoot";
var hiresImagesKey = "hiresImages"

// Random number in given range.
// Got from:
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
function getRandomNumber(min, max)
{
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getSlideshowOrder(count, randomize) {
    var arr = Array(count)
    for (var j = 0; j < arr.length; ++j) {
      arr[j] = j
    }

    if (randomize) {
        var randomized = []
        while(arr.length > 0)
        {
            var ind = getRandomNumber(0, (arr.length - 1))
            randomized.push(arr.splice(ind, 1))
        }
        arr = randomized
    }

    return arr
}
