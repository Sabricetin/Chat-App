# Chat-App

Chat-App, kullanıcılar arasında gerçek zamanlı mesajlaşmayı sağlayan modern bir iOS uygulamasıdır. Uygulama, mesaj verilerini yönetmek ve senkronize etmek için Firebase Realtime Database’i kullanır.

---

## Özellikler

- **Gerçek Zamanlı Mesajlaşma:**  
  Firebase Realtime Database entegrasyonu sayesinde mesajlar anlık olarak alınır ve güncellenir.

- **Mesaj Modeli:**  
  - `senderUid`: Mesajı gönderen kullanıcının benzersiz kimliği.  
  - `message`: Gönderilen mesajın içeriği.  
  - `isRead`: Mesajın okunma durumunu belirten bilgi.

- **Swift Package Manager ile Entegrasyon:**  
  Uygulama, bağımlılık yönetimi için Swift Package Manager (SPM) kullanılarak geliştirilmiştir.

---

## Kurulum

1. **Projeyi Klonlayın**

   ```bash
   git clone https://github.com/<kullanici_adiniz>/Chat-App.git

	2.	Xcode ile Açın
Proje dizinine gidin ve Chat-App.xcodeproj dosyasını Xcode ile açın.
	3.	Firebase Entegrasyonu
	•	Firebase Console üzerinden yeni bir proje oluşturun.
	•	GoogleService-Info.plist dosyasını indirin ve Xcode projenize ekleyin.
	•	Firebase bağımlılıkları, Swift Package Manager kullanılarak projeye eklenmiştir. Gerekli paketleri Xcode üzerinden File > Swift Packages > Add Package Dependency… seçeneğini kullanarak ekleyebilirsiniz (örneğin FirebaseDatabase).
	4.	Projeyi Çalıştırın
Xcode üzerinden uygun bir simülatör veya bağlı cihaz seçerek projeyi derleyip çalıştırın.

Kullanım
	•	Mesaj Listesi:
Firebase’den alınan veriler dinamik olarak işlenir ve uygulama içerisinde mesaj listesi arayüzünde görüntülenir.
	•	Mesaj Gönderimi:
Yeni mesaj oluşturulurken, gönderici bilgisi ve mesaj içeriği Firebase’e gönderilir.
	•	Okunma Durumu:
isRead özelliği sayesinde, mesajların okunma durumları takip edilip kullanıcı arayüzünde uygun şekilde işaretlenir.

Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen katkıda bulunmadan önce CONTRIBUTING.md dosyasını inceleyin.

Lisans

Bu proje, MIT Lisansı kapsamında lisanslanmıştır.

İletişim

Linkedin: https://www.linkedin.com/in/sabricetin/
Gmail: sabriyazilim@gmail.com

Herhangi bir sorun veya öneriniz için benimle iletişime geçebilirsiniz.

