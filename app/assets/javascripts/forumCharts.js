var totalPosts = 0;

function drawEmailCharts() {
  emptyContainers();
  drawEmailPieChart();
}

function drawPosterCharts() {
  emptyContainers();
  drawPosterBarChart();
  drawPosterPieChart();
}
//nämä käyttävät chartDrawer.js:n drawPieChartia
function drawEmailPieChart() {
    insertTitle("Sähköpostien palveluntarjoajat");
    drawPieChart("emails", $("#user_data").data().emailcounts, true, "#chart svg");
}

function drawPosterBarChart() {
  drawBarChart(divideUsersIntoPostCountGroups(), "#chart2 svg");
}

function drawPosterPieChart() {
    insertTitle("Käyttäjien viestit");
    insertMinButton();
    drawWithMinPosts(10);
}

function drawWithMinPosts(minPosts) {
    if (minPosts > 0) {
        var postdata = getPostCountsByUsers($("#user_data").data().postcounts, minPosts);
        drawPieChart("posts", postdata, true, "#chart svg");
        insertTitle("Viimeiset " + totalPosts + " viestiä käyttäjien mukaan");
    }
}

//Ohjaa haettavan Qt:n foorumin käyttäjän sivuille
function redirectToQtUserPage(name) {
    if (!name.includes("users w/")) window.open("http://forum.qt.io/user/" + name);
}

//Hakee erikseen postausmäärät käyttäjiltä joilla on yli n postia ja laskee
//myös yhteen alle n-postisten käyttäjien postausmäärän.
function getPostCountsByUsers(postCounts, minPosts) {
    totalPosts = 0;
    var data = []
    var postCountForGroupedUsers = 0;
    for (var postCount in postCounts) {
        totalPosts += postCounts[postCount].value;
        if (postCounts[postCount].value < minPosts) {
            postCountForGroupedUsers++;
        } else {
            data.push(postCounts[postCount])
        }
    }
    data.push({
        "label": "users w/ <" + minPosts + " posts",
        "value": postCountForGroupedUsers
    })
    return objectSorter(data);
}

//Listaa sivulla kaikki yhden palveluntarjoajan käyttäjät
function listUsersOfProvider(emailprovider) {
    document.getElementById("usernames").innerHTML = "";
    document.getElementById("usernames").innerHTML += "<h2>Käyttäjät tarjoajalla " + emailprovider + "</h2>";
    var objectArray = $("#user_data").data().usersbyemail[emailprovider],
        userArray = [];
    for (var i = 0; i < objectArray.length; i++) {
        userArray.push(objectArray[i].user)
    }
    document.getElementById("usernames").appendChild(makeUL(userArray));
}

function insertMinButton() {
    document.getElementById("buttonFeature").innerHTML =
        "<input type=number value=10 id='minimum'/><p><input type = button value = 'Aseta viestien minimimäärä' onclick = 'drawWithMinPosts(document.getElementById(&quot;minimum&quot;).value)'></input></p>";
}

function emptyContainers() {
    document.getElementById("buttonFeature").innerHTML = "";
    document.getElementById("usernames").innerHTML = "";
    if (document.getElementById("barChartTitle")) document.getElementById("barChartTitle").innerHTML = "";
    emptyCharts();
}

function divideUsersIntoPostCountGroups() {
  var dataMap = new Map();
  dataMap.set("1", 0);
  dataMap.set("2", 0);
  dataMap.set("3-5", 0);
  dataMap.set("6-9", 0);
  dataMap.set("10-19", 0);
  dataMap.set("20-49", 0);
  dataMap.set("50-99", 0);
  dataMap.set("100+", 0);

  var data = [];
  var postCounts = objectSorter($("#user_data").data().postcounts);
  for (i in postCounts) {
    var posts = postCounts[i].value
    if (posts === 1) dataMap.set("1", dataMap.get("1")+1);
    if (posts === 2) dataMap.set("2", dataMap.get("2")+1);
    if (posts >= 3 && posts <= 5) dataMap.set("3-5", dataMap.get("3-5")+1);
    if (posts >= 6 && posts <= 9) dataMap.set("6-9", dataMap.get("6-9")+1);
    if (posts >= 10 && posts <= 19) dataMap.set("10-19", dataMap.get("10-19")+1);
    if (posts >= 20 && posts <= 49) dataMap.set("20-49", dataMap.get("20-49")+1);
    if (posts >= 50 && posts <= 99) dataMap.set("50-99", dataMap.get("50-99")+1);

    if(posts >=100) dataMap.set("100+", dataMap.get("100+")+1);
  }

  for (var key of dataMap.keys()) {
    data.push({
      "label": key,
      "value": dataMap.get(key)
    })
  }
  return data;
}
