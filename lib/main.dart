import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  int sayacRenk=-1;
  String dersAdi = "";
  int dersKredi = 4;
  int dersNotu ;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Ortalama Hesapla",
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              child: FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    tumDersler.clear();
                  });
                },
                label: Text("Hepsini Sil",style: TextStyle(color: Colors.tealAccent),),
                icon: Icon(
                  Icons.add,
                  color: Colors.tealAccent,
                ),
                backgroundColor: Colors.black,

              ),
              alignment: Alignment.bottomLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              child: FloatingActionButton.extended(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                  }
                },
                label: Text("Ekle",style: TextStyle(color: Colors.tealAccent),),
                icon: Icon(
                  Icons.add,
                  color: Colors.tealAccent,
                ),
                backgroundColor: Colors.black,

              ),
              alignment: Alignment.bottomLeft,
            ),
          ),
        ],
      ),
      body: UygulamaGovdesi(),
    );
  }


  Widget UygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //STATİC FORMU TUTAN CONTAİNER
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            // color: Colors.pink.shade200,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Ders Adi",
                      hintText: "Ders adını giriniz",
                      hintStyle: TextStyle(fontSize: 18),
                      labelStyle:
                          TextStyle(fontSize: 16, color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.tealAccent, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.tealAccent, width: 2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    initialValue: "Matematik 1",
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0) {
                        return null;
                      } else
                        return "Ders Adı boş olamaz";
                    },
                    onSaved: (kaydedilecekDeger) {
                      dersAdi = kaydedilecekDeger;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: DropdownButton<int>(
                          items: dersKrediItems(),
                          value: dersKredi,
                          onChanged: (secilenKredi) {
                            setState(() {
                              dersKredi = secilenKredi;
                            });
                          },
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.tealAccent, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Ders Notu",
                            hintText: "Ders Notunu Giriniz",
                            hintStyle: TextStyle(fontSize: 18),
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.tealAccent, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.tealAccent, width: 2)),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: (girilenDeger) {
                            if ((girilenDeger.length>0)&&((int.parse(girilenDeger)<100)&&(int.parse(girilenDeger)>0))) {
                              return null;
                            } else
                              return "Aralıkta Bir Değer Giriniz";
                          },
                          onSaved: (kaydedilecekDeger) {
                            dersNotu = int.parse(kaydedilecekDeger);

                            setState(() {
                              tumDersler.add(Ders(
                                  dersAdi,
                                  dersKredi,
                                  rastgeleRengOlustur(),
                                  dersNotu,
                                  harfNotuBulanFonksiyon()));
                              ortalama = 0;
                              ortalamayiHesapla();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.tealAccent,
                  width: 2,
                )),
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                //text span textimizin içindekileri parçalara ayırmamıza yardımcı olur ayrı şekilde özelleştirebiliriz
                children: [
                  TextSpan(
                    text: "Ortalama : ",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.tealAccent,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: tumDersler.length == 0
                        ? "0.0"
                        : "${ortalama.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
          ),

          //DİNAMİK LİSTE TUTAN CONTAİNER
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              // color: Colors.green.shade200,
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.tealAccent, width: 2)),
            ),
          ),
        ],
      ),
    );
  }



  List<DropdownMenuItem<int>> dersKrediItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text("$i Kredi"),
      ));
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> dersNotuItems() {
    List<DropdownMenuItem<double>> notlar = [];
    for (double i = 1; i <= 100; i++) {
      notlar.add(DropdownMenuItem<double>(
        value: i,
        child: Text("$i"),
      ));
    }
    return notlar;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: tumDersler[index].renk,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            margin: EdgeInsets.all(4),
            child: ListTile(
              leading: Icon(
                Icons.book,
                size: 36,
                color: Colors.black,
              ),
              title: Text(
                tumDersler[index].ad,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                tumDersler[index].harf,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Kredisi " +
                    tumDersler[index].kredi.toString() +
                    " " +
                    "     Alınan Not: " +
                    tumDersler[index].not.toString(),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void ortalamayiHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;

    for (var oankiDers in tumDersler) {
      var kredi = oankiDers.kredi;
      var not = oankiDers.not;

      toplamNot = toplamNot + (not * kredi);
      toplamKredi += kredi;
    }

    ortalama = toplamNot / toplamKredi;
  }

  Color rastgeleRengOlustur() {

    List<Color> renkler = [
      Colors.deepPurple,
      Colors.blue.shade600,
      Colors.red,
      Colors.cyan,
      Colors.green,
      Colors.indigo,
      Colors.amber,
      Colors.purpleAccent,
      Colors.redAccent
    ];

    sayacRenk++;

    if(sayacRenk<9){
      return renkler[sayacRenk];
    }else{
      sayacRenk=0;
      return renkler[0];
    }


  }

  String harfNotuBulanFonksiyon() {
    if (dersNotu > 90) {
      return "AA";
    } else if (dersNotu > 84 && dersNotu < 90) {
      return "BA";
    } else if (dersNotu > 79 && dersNotu < 85) {
      return "BB";
    } else if (dersNotu > 69 && dersNotu < 80) {
      return "CB";
    } else if (dersNotu > 59 && dersNotu < 70) {
      return "CC";
    } else if (dersNotu > 54 && dersNotu < 60) {
      return "DC";
    } else if (dersNotu > 49 && dersNotu < 55) {
      return "DD";
    } else if (dersNotu > 39 && dersNotu < 50) {
      return "FD";
    } else if (dersNotu <= 39) {
      return "FF";
    }
  }
}

class Ders {
  String ad;
  String harf;
  double harfDegeri;
  int kredi;
  Color renk;
  int not;

  Ders(this.ad, this.kredi, this.renk, this.not, this.harf);
}


/*

  Widget UygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                // color: Colors.pink.shade200,
                child: Form(
                  key: formKey,
                  child: Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Ders Adi",
                            hintText: "Ders adını giriniz",
                            hintStyle: TextStyle(fontSize: 18),
                            labelStyle:
                            TextStyle(fontSize: 16, color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.tealAccent, width: 2),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.tealAccent, width: 2)),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: (girilenDeger) {
                            if (girilenDeger.length > 0) {
                              return null;
                            } else
                              return "Ders Adı boş olamaz";
                          },
                          onSaved: (kaydedilecekDeger) {
                            dersAdi = kaydedilecekDeger;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: DropdownButton<int>(
                                items: dersKrediItems(),
                                value: dersKredi,
                                onChanged: (secilenKredi) {
                                  setState(() {
                                    dersKredi = secilenKredi;
                                  });
                                },
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.tealAccent, width: 2),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Ders Notu",
                                  hintText: "Ders Notunu Giriniz",
                                  hintStyle: TextStyle(fontSize: 18),
                                  labelStyle: TextStyle(
                                      fontSize: 16, color: Colors.white70),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.tealAccent, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.tealAccent, width: 2)),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                validator: (girilenDeger) {
                                  if ((int.parse(girilenDeger) >= 0) &&
                                      (int.parse(girilenDeger) <= 100)) {
                                    return null;
                                  } else
                                    return "Aralıkta Bir Değer Giriniz";
                                },
                                onSaved: (kaydedilecekDeger) {
                                  dersNotu = int.parse(kaydedilecekDeger);

                                  setState(() {
                                    tumDersler.add(Ders(
                                        dersAdi,
                                        dersKredi,
                                        rastgeleRengOlustur(),
                                        dersNotu,
                                        harfNotuBulanFonksiyon()));
                                    ortalama = 0;
                                    ortalamayiHesapla();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.tealAccent,
                      width: 2,
                    )),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      //text span textimizin içindekileri parçalara ayırmamıza yardımcı olur ayrı şekilde özelleştirebiliriz
                      children: [
                        TextSpan(
                          text: "Ortalama : ",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: tumDersler.length == 0
                              ? "0.0"
                              : "${ortalama.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            // color: Colors.green.shade200,
            child: ListView.builder(
              itemBuilder: _listeElemanlariniOlustur,
              itemCount: tumDersler.length,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.tealAccent, width: 2)),
          ),
        ],
      ),
    );
  }


 */