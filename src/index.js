const express = require("express");
const app = express();

app.get("/", (req, res) => {
  const ip = req.socket.remoteAddress; //pobranie adresu IP
  var datetime;
  fetch("https://ipapi.co/json/") //wysłanie zapytania do API, z którego można odczytać informacje na temat strefy czasowej za pośrednictwem adresu IP
    .then((response) => response.json())
    .then((data) => {
      const timeZone = data.timezone; //pobranie strefy czasowej
      //console.log(timeZone);

      //określenie daty i godziny na podstawie strefy czasowej
      const datetime = new Date().toLocaleDateString("en-GB", {
        timeZone: timeZone,
      });

      //wyświetlenie adresu IP, daty i czasu
      res.send("IP: " + ip + "<br>" + "Data i czas: " + datetime);
    });
});

app.listen(8080, () => {
  const currentDate = new Date().toDateString(); //pobranie bieżącej daty
  //zapisanie w logach informacji o dacie uruchomienia, autorze i numerze portu
  console.log("Data uruchomienia: " + currentDate);
  console.log("Autor: Maciej Przyłucki");
  console.log("Nasłuchiwanie na porcie 8080");
});
