import 'package:flutter/material.dart';
import 'package:nothesaplama/constants/app_constant.dart';
import 'package:nothesaplama/widgets/ders_listesi.dart';
import 'package:nothesaplama/widgets/harf_dropdown_widgets.dart';
import 'package:nothesaplama/widgets/kredi_dropdown_widgets.dart';
import 'package:nothesaplama/widgets/ortalama_goster_page.dart';

import '../helper/data_helper.dart';
import '../model/ders.dart';

class OrtalamaHesaplaPage extends StatefulWidget {
  const OrtalamaHesaplaPage({super.key});

  @override
  State<OrtalamaHesaplaPage> createState() => _OrtalamaHesaplaPageState();
}

class _OrtalamaHesaplaPageState extends State<OrtalamaHesaplaPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  double secilenHarfDegeri = 4;
  double secilenKrediDegeri = 1;
  String girilenDersAdi = '';

  List<Ders> tumDersler = DataHelper.tumEklenenDersler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Center(
            child: Text(
              Sabitler.baslikText,
              style: Sabitler.baslikStyle,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildForm(),
                ),
                Expanded(
                  flex: 1,
                  child: OrtalamaGoster(
                      dersSayisi: DataHelper.tumEklenenDersler.length,
                      ortalama: DataHelper.ortalamaHesapla()),
                ),
              ],
            ),
            Expanded(
              child: DersListesi(
                onElemanCikarildi: (index) {
                  DataHelper.tumEklenenDersler.removeAt(index);
                  setState(() {});
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: Sabitler.yatayPadding8,
            child: _buildTextFormBuild(),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: Sabitler.yatayPadding8,
                  child: HarfDropdownWidget(
                    onHarfSecildi: (harf) {
                      secilenHarfDegeri = harf;
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: Sabitler.yatayPadding8,
                    child: KrediDropdownWidget(
                      onKrediSecildi: (kredi) {
                        secilenKrediDegeri = kredi;
                      },
                    )),
              ),
              IconButton(
                onPressed: _dersEkleveOrtalamaHesapla,
                icon: const Icon(Icons.arrow_forward_ios_sharp),
                color: Sabitler.anaRenk,
                iconSize: 30,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  _buildTextFormBuild() {
    return TextFormField(
      onSaved: (deger) {
        setState(() {
          girilenDersAdi = deger!;
        });
      },
      validator: (s) {
        if (s!.isEmpty) {
          return 'Ders adını giriniz';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          hintText: 'Ders Adı Giriniz',
          border: OutlineInputBorder(
            borderRadius: Sabitler.borderRadius,
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey),
    );
  }

  void _dersEkleveOrtalamaHesapla() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var eklenecekDers = Ders(
          ad: girilenDersAdi,
          harfDegeri: secilenHarfDegeri,
          krediDegeri: secilenKrediDegeri);
      DataHelper.dersEkle(eklenecekDers);

      print(DataHelper.ortalamaHesapla());
      setState(() {});
    }
  }
}
