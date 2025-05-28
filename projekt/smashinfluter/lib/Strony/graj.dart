import 'package:flutter/material.dart';

class _TematInfo {
  final String title;
  final String description;
  final String imagePath;

  _TematInfo(this.title, this.description, this.imagePath);
}

class GrajPage extends StatefulWidget {
  @override
  _GrajPageState createState() => _GrajPageState();
}

class _GrajPageState extends State<GrajPage> {
  final List<_TematInfo> tematy = [
    _TematInfo(
      'Zasady',
      'Podstawowe zasady gry w Padla. '
          'W grze chodzi o odbijanie piłki rakietą nad siatką w wyznaczone pole przeciwnika.'
          'Główną różnicą pomiedzy tenisem jest to, że piłka może się odbijać od ścian pod'
          ' warunkiem że najpierw odbije się od ziemi.'
          'Wygrywa się punkty, gemy, sety i mecze tak samo jak w tenisie.'
          'Drugim popularnym systemem punktowym jest americano w gra się do 21 punktów'
          'Drużyna serwuje 2 punkty z rzędu, później następuje zmiana',
      'assets/images/1.jpg',
    ),
    _TematInfo(
      'Rodzaje uderzeń',
      'Forehand, backhand, serwis i overhead  to podstawowe uderzenia w padlu. '
          'Forehand to uderzenie po stronie ręki dominującej, backhand po przeciwnej. '
          'Serwis rozpoczyna każdą akcję i jest kluczowy w grze.'
          'Overhead to rodzina uderzeń które polegają na uderzeniu w powietrzu nad poziomem głowy',
      'assets/images/uderzenia.jpg',
    ),
    _TematInfo(
      'Kort',
      'Korty do padla mają wymiary 20m długości na 10m szerokości.'
          'Kort jest otoczony szklanymi ścianami z tyłu oraz częściowo z boku o wyskości 3m'
          'Natomiast boczne ściany wykonane są z metalowej siatki o wysokości 3m i na '
          'tylniej szybie znajduje się dodatkowo metr metalowej siatki '
          'Każdy typ wpływa na styl gry, odbicia piłki i szybkość poruszania się zawodników.',
      'assets/images/kort.jpg',
    ),
    _TematInfo(
      'Rakieta',
      'Dobór rakiety zależy od stylu gry, wieku i poziomu umiejętności.'
          'Kształt rakiety ma duży wpływ na łatwość grania,'
          'bardziej okragły kształt generuje mniej mocy jednak łatwiej jest czysto trafić w piłke '
          'Ważne są waga, balans, powierzchnia główki.',
      'assets/images/rakieta.jpg',
    ),
  ];

  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    expanded = List.filled(tematy.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final imageHeight = screenHeight * 0.20; // Większa wysokość obrazka

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tematy.length,
      itemBuilder: (context, index) {
        final temat = tematy[index];
        final isExpanded = expanded[index];

        return GestureDetector(
          onTap: () {
            setState(() {
              expanded[index] = !isExpanded;
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            clipBehavior: Clip.antiAlias,
            // automatyczne zaokrąglenie zawartości
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  temat.imagePath,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temat.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            temat.description,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}