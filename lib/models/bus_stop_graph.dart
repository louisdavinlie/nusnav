import 'package:flutter/material.dart';

class BusStopGraph {
  static Map<String, List<Map<String, String>>> graph = {
    "AS 5": [
      {
        "bus": "A1",
        "nextBusStop": "COM 2",
      },
      {
        "bus": "D1",
        "nextBusStop": "COM 2",
      },
      {
        "bus": "B1",
        "nextBusStop": "BIZ 2",
      },
      {
        "bus": "BTC1",
        "nextBusStop": "BIZ 2",
      },
    ],
    "BIZ 2": [
      {
        "bus": "A1",
        "nextBusStop": "Opp TCOMS",
      },
      {
        "bus": "D1",
        "nextBusStop": null,
      },
      {
        "bus": "B1",
        "nextBusStop": null,
      },
      {
        "bus": "BTC1",
        "nextBusStop": "Prince George's Park",
      },
      {
        "bus": "A1E",
        "nextBusStop": "Prince George's Park",
      },
    ],
    "Botanic Gardens MRT": [
      {
        "bus": "BTC2",
        "nextBusStop": "Museum",
      }
    ],
    "Oei Tiong Ham Building": [
      {
        "bus": "BTC1",
        "nextBusStop": null,
      },
      {
        "bus": "BTC2",
        "nextBusStop": "Botanic Gardens MRT",
      },
    ],
    "Central Library": [
      {
        "bus": "A1",
        "nextBusStop": "LT 13",
      },
      {
        "bus": "D1",
        "nextBusStop": "LT 13",
      },
      {
        "bus": "B1",
        "nextBusStop": "LT 13",
      },
      {
        "bus": "BTC1",
        "nextBusStop": "LT 13",
      },
      {
        "bus": "A1E",
        "nextBusStop": "BIZ 2",
      },
    ],
    "College Green": [
      {
        "bus": "BTC1",
        "nextBusStop": "Oei Tiong Ham Building",
      },
    ],
    "COM 2": [
      {
        "bus": "A1",
        "nextBusStop": "BIZ 2",
      },
      {
        "bus": "A2",
        "nextBusStop": "Ventus",
      },
      {
        "bus": "D1",
        "nextBusStop": "Ventus",
      },
      {
        "bus": "D1",
        "nextBusStop": "BIZ 2",
      },
    ],
    "EA": [
      {
        "bus": "B2",
        "nextBusStop": "Kent Ridge Bus Terminal",
      },
      {
        "bus": "BTC2",
        "nextBusStop": "Kent Ridge Bus Terminal",
      },
      {
        "bus": "C",
        "nextBusStop": "Kent Ridge Bus Terminal",
      },
    ],
    "Information Technology": [
      {
        "bus": "A2",
        "nextBusStop": "Opp Yusof Ishak House",
      },
      {
        "bus": "D1",
        "nextBusStop": "Opp Yusof Ishak House",
      },
      {
        "bus": "B1",
        "nextBusStop": "Opp Yusof Ishak House",
      },
      {
        "bus": "B2",
        "nextBusStop": "Opp Yusof Ishak House",
      },
      {
        "bus": "A2E",
        "nextBusStop": "S 17",
      },
    ],
    "Kent Ridge Bus Terminal": [
      {
        "bus": "B1",
        "nextBusStop": "Information Technology",
      },
      {
        "bus": "B2",
        "nextBusStop": null,
      },
      {
        "bus": "BTC1",
        "nextBusStop": "Kent Vale",
      },
      {
        "bus": "BTC2",
        "nextBusStop": null,
      },
      {
        "bus": "C",
        "nextBusStop": "The Japanese Primary School",
      },
    ],
    "Kent Ridge MRT": [
      {
        "bus": "A1",
        "nextBusStop": "LT 27",
      },
      {
        "bus": "D2",
        "nextBusStop": "LT 27",
      },
      {
        "bus": "A1E",
        "nextBusStop": "LT 27",
      },
    ],
    "Kent Vale": [
      {
        "bus": "BTC1",
        "nextBusStop": "Museum",
      },
      {
        "bus": "C",
        "nextBusStop": "Museum",
      },
    ],
    "LT 13": [
      {
        "bus": "A1",
        "nextBusStop": "AS 5",
      },
      {
        "bus": "D1",
        "nextBusStop": "AS 5",
      },
      {
        "bus": "B1",
        "nextBusStop": "AS 5",
      },
      {
        "bus": "BTC1",
        "nextBusStop": "AS 5",
      },
    ],
    "LT 27": [
      {
        "bus": "A1",
        "nextBusStop": "University Hall",
      },
      {
        "bus": "D2",
        "nextBusStop": "University Hall",
      },
      {
        "bus": "A1E",
        "nextBusStop": "Opp University Health Centre",
      },
      {
        "bus": "C",
        "nextBusStop": "University Hall",
      },
    ],
    "Museum": [
      {
        "bus": "A2",
        "nextBusStop": "University Health Centre",
      },
      {
        "bus": "D1",
        "nextBusStop": "University Town",
      },
      {
        "bus": "D2",
        "nextBusStop": "University Town",
      },
      {
        "bus": "BTC1",
        "nextBusStop": "Yusof Ishak House",
      },
      {
        "bus": "BTC2",
        "nextBusStop": "EA",
      },
      {
        "bus": "C",
        "nextBusStop": "University Town",
      }
    ],
    "Opp Hon Sui Sen Memorial Library": [
      {
        "bus": "A2",
        "nextBusStop": "Opp NUSS",
      },
      {
        "bus": "D1",
        "nextBusStop": "Opp NUSS",
      },
      {
        "bus": "B2",
        "nextBusStop": "Opp NUSS",
      },
    ],
    "Opp Kent Ridge MRT": [
      {
        "bus": "A2",
        "nextBusStop": "Prince George's Park",
      },
      {
        "bus": "D2",
        "nextBusStop": "Prince George Park Residences",
      },
      {
        "bus": "A2E",
        "nextBusStop": null,
      },
    ],
    "Opp NUSS": [
      {
        "bus": "A2",
        "nextBusStop": "COM 2",
      },
      {
        "bus": "D1",
        "nextBusStop": "COM 2",
      },
      {
        "bus": "B2",
        "nextBusStop": "Ventus",
      },
    ],
    "Opp TCOMS": [
      {
        "bus": "A1",
        "nextBusStop": "PGP7",
      },
      {
        "bus": "D2",
        "nextBusStop": "Prince George's Park",
      },
    ],
    "Opp University Hall": [
      {
        "bus": "A2",
        "nextBusStop": "S 17",
      },
      {
        "bus": "D2",
        "nextBusStop": "S 17",
      },
      {
        "bus": "C",
        "nextBusStop": "S 17",
      },
    ],
    "Opp University Health Centre": [
      {
        "bus": "A1",
        "nextBusStop": "Yusof Ishak House",
      },
      {
        "bus": "D2",
        "nextBusStop": "Museum",
      },
      {
        "bus": "A1E",
        "nextBusStop": "Central Library",
      },
      {
        "bus": "C",
        "nextBusStop": "University Town",
      },
    ],
    "Opp Yusof Ishak House": [
      {
        "bus": "A2",
        "nextBusStop": "Museum",
      },
      {
        "bus": "D1",
        "nextBusStop": "Museum",
      },
      {
        "bus": "B1",
        "nextBusStop": "University Town",
      },
      {
        "bus": "B2",
        "nextBusStop": "University Town",
      },
    ],
    "PGP House 15": [
      {
        "bus": "A2",
        "nextBusStop": "TCOMS",
      },
    ],
    "PGP7": [
      {
        "bus": "A1",
        "nextBusStop": "Prince George's Park",
      },
    ],
    "Prince George's Park": [
      {
        "bus": "A1",
        "nextBusStop": "Kent Ridge MRT",
      },
      {
        "bus": "A2",
        "nextBusStop": "PGP House 15",
      },
      {
        "bus": "D2",
        "nextBusStop": "Kent Ridge MRT",
      },
      {
        "bus": "BTC1",
        "nextBusStop": "College Green",
      },
      {
        "bus": "A1E",
        "nextBusStop": null,
      },
    ],
    "Prince George Park Residences": [
      {
        "bus": "D2",
        "nextBusStop": "TCOMS",
      },
    ],
    "Raffles Hall": [
      {
        "bus": "B2",
        "nextBusStop": "EA",
      },
      {
        "bus": "C",
        "nextBusStop": "EA",
      },
    ],
    "S 17": [
      {
        "bus": "A2",
        "nextBusStop": "Opp Kent Ridge MRT",
      },
      {
        "bus": "D2",
        "nextBusStop": "Opp Kent Ridge MRT",
      },
      {
        "bus": "A2E",
        "nextBusStop": "Opp Kent Ridge MRT",
      },
      {
        "bus": "C",
        "nextBusStop": "LT 27",
      }
    ],
    "TCOMS": [
      {
        "bus": "A2",
        "nextBusStop": "Opp Hon Sui Sen Memorial Library",
      },
      {
        "bus": "D2",
        "nextBusStop": null,
      },
    ],
    "The Japanese Primary School": [
      {
        "bus": "C",
        "nextBusStop": "Kent Vale",
      },
    ],
    "University Hall": [
      {
        "bus": "A1",
        "nextBusStop": "Opp University Health Centre",
      },
      {
        "bus": "D2",
        "nextBusStop": "Opp University Health Centre",
      },
      {
        "bus": "C",
        "nextBusStop": "Opp University Health Centre",
      },
    ],
    "University Health Centre": [
      {
        "bus": "A2",
        "nextBusStop": "Opp University Hall",
      },
      {
        "bus": "D2",
        "nextBusStop": "Opp University Hall",
      },
      {
        "bus": "C",
        "nextBusStop": "Opp University Hall",
      },
    ],
    "University Town": [
      {
        "bus": "D1",
        "nextBusStop": "Yusof Ishak House",
      },
      {
        "bus": "D2",
        "nextBusStop": "University Health Centre",
      },
      {
        "bus": "B1",
        "nextBusStop": "Yusof Ishak House",
      },
      {
        "bus": "B2",
        "nextBusStop": "Raffles Hall",
      },
      {
        "bus": "C",
        "nextBusStop": "University Health Centre",
      },
      {
        "bus": "C",
        "nextBusStop": "Raffles Hall",
      }
    ],
    "Ventus": [
      {
        "bus": "A2",
        "nextBusStop": "Information Technology",
      },
      {
        "bus": "D1",
        "nextBusStop": "Information Technology",
      },
      {
        "bus": "B2",
        "nextBusStop": "Information Technology",
      },
      {
        "bus": "A2E",
        "nextBusStop": "Information Technology",
      },
    ],
    "Yusof Ishak House": [
      {
        "bus": "A1",
        "nextBusStop": "Central Library",
      },
      {
        "bus": "D1",
        "nextBusStop": "Central Library",
      },
      {
        "bus": "B1",
        "nextBusStop": "Central Library",
      },
      {
        "bus": "BTC1",
        "nextBusStop": "Central Library",
      },
    ],
  };

  static Future<List> findPath(
    String originBusStop,
    String destinationBusStop,
    List routes,
    List previousBus,
    int maxNoOfBusToTake,
  ) async {
    try {
      List result = [];
      List<Map<String, String>> child = graph[originBusStop];

      if (originBusStop != destinationBusStop) {
        for (int i = 0; i < child.length; i++) {
          List routesSoFar = List.from(routes);
          List previousBusCopy = List.from(previousBus);

          String nextBusStop = child[i]["nextBusStop"];
          String bus = child[i]["bus"];

          if (previousBusCopy[0] != bus) {
            previousBusCopy[0] = bus;
            previousBusCopy[1] += 1;
          }

          previousBusCopy[2] += 1;

          if (nextBusStop != null) {

            List routeToNextBusStop = [bus, nextBusStop.toUpperCase()];

            routesSoFar.add(routeToNextBusStop);

            if (previousBusCopy[1] < (maxNoOfBusToTake + 1) &&
                previousBusCopy[2] < 17) {
              print(previousBusCopy);
              if (nextBusStop == destinationBusStop) {
                print(routesSoFar);
                result.add([routesSoFar, previousBusCopy]);
              } else {
                result.addAll(await findPath(
                  nextBusStop,
                  destinationBusStop,
                  routesSoFar,
                  previousBusCopy,
                  maxNoOfBusToTake,
                ));
              }
            }
          }
        }
      }
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
