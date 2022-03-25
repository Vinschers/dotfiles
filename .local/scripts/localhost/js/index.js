setInterval(displayClock, 1000);

function displayClock() {
    const time = document.getElementById('time');
    let date = new Date();
    let hrs = date.getHours();
    let min = date.getMinutes();
    if (hrs < 10) {
        hrs = "0" + hrs
    }
    if (min < 10) {
        min = "0" + min
    }
    time.textContent = hrs + ':' + min;
}

function onload () {
    const greeting = document.getElementById('greeting');

    const date = new Date();
    const hour = date.getHours();
    const min = date.getMinutes();
    const time = 60 * hour + min;

    let timePeriod = "morning";

    if (time < 360 || time >= 1110) {
        timePeriod = "evening";
    } else if (time > 720 && time < 1110) {
        timePeriod = "afternoon";
    }

    const greetingMessage = "Good " + timePeriod + ", " + greeting.textContent + "!";
    greeting.textContent = greetingMessage;

    displayClock();
}

function isValidUrl(string) {
    const regexp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
    return regexp.test(string);
}

function onSearch(event) {
    let input = document.getElementById('search_query').value

    if (isValidUrl(input)) {
        if (!input.startsWith('http'))
            input = 'https://' + input

        const anchorTag = document.createElement('a');
        anchorTag.href = input;
        anchorTag.click();
        return false;
    }
    
    return true;
}

onload();
