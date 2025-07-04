# 🌿 Akıllı Tarım: Yapay Zeka Destekli Bitki Hastalık ve Zararlı Tespiti

Bu proje, tarım alanında bitki sağlığını korumak ve üretkenliği artırmak amacıyla geliştirilen bir **yapay zeka destekli mobil uygulamadır**. Geliştirdiğim sistem, çeşitli bitki türlerinin yapraklarındaki hastalıkları ve zararlıları tespit ederek kullanıcıya **hızlı, doğru ve öneri odaklı bilgiler** sunar. Aynı zamanda sürdürülebilir tarım konusunda bilgilendirmeyi hedefler.

---

## 📱 Proje Özellikleri

- 🌱 **5 farklı bitki için hastalık tespiti:** Üzüm, mısır, patates, elma 
- 🐞 **Zararlı (böcek) tespiti**: Görüntü üzerinden böcek algılama modeli
- 🔗 **Mobil uygulama ile API iletişimi**
- 📚 **Sürdürülebilir tarım içerikleri**: Bilgilendirici yazılar, görseller ve videolar
- 🌍 Kullanıcı dostu, bilgilendirici ve pratik kullanım arayüzü
- 🔗 Veritabanı olarak firebase kullanılmıştır.

---

## 🧠 Kullanılan Modeller

| Model No | Bitki Türü       | Açıklama                           |
|----------|------------------|------------------------------------|
| 1        | Üzüm             | Yaprak hastalık tespiti           |
| 2        | Mısır            | Hastalık sınıflandırma            |
| 3        | Patates          | Erken ve geç yanıklık tespiti     |
| 4        | Elma             | Yaprak lekesi ve mantar hastalıkları |
| 5        | Böcek Tespiti    | Böcek detection modeli      |

> Modellerin bazıları eğitimli CNN tabanlı mimarilerle(Resnet vb.) bazıları ise kendi oluşturduğum mimariyle eğitilmiştir.

---

## 🔌 API Entegrasyonu

Modeller bir web sunucusu üzerinden API olarak sunulmuştur. Mobil uygulama ile aşağıdaki şekilde haberleşir:

1. 📷 Görüntü mobil uygulama üzerinden API'ye gönderilir.
2. 🧠 Model sonucu işler ve sınıflandırma/detection yapar.
3. 📝 Tespit sonucu ve öneriler mobil uygulama ekranında gösterilir.




