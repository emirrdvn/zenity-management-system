# Zenity ile Gelişmiş Envanter Yönetim Sistemi

Bu proje, Zenity kullanarak bir envanter yönetim sistemi geliştirmek için hazırlanmıştır. Kullanıcı dostu bir arayüz ve kapsamlı işlevler sunarak envanter yönetimini kolaylaştırmayı amaçlar.

## Özellikler

- Ürün ekleme, listeleme, güncelleme ve silme işlemleri
- Kullanıcı yönetimi (ekleme, listeleme, güncelleme, silme)
- Raporlama (stok analizi ve yüksek stoklu ürünler)
- Kullanıcı doğrulama ve yetkilendirme (admin ve standart kullanıcı)
- Hata kayıtları için log dosyası oluşturma

## Gereksinimler

- Bash kabuğu
- Zenity (Linux sistemlerinde varsayılan olarak bulunur veya paket yöneticisi ile yüklenebilir)

## Kullanım

1. **Projenin Başlatılması:**
    - Terminalden `bash <script_ismi>.sh` komutunu çalıştırın.
2. **Kullanıcı Girişi:**
    - Kullanıcı adınızı ve şifrenizi girerek giriş yapın.
    - Giriş başarılıysa ana menüye yönlendirilirsiniz.
3. **Ana Menü İşlevleri:**
    - **Admin Rolü:** Ürün ve kullanıcı yönetimi dahil tüm işlemlere erişim.
    - **Standart Kullanıcı:** Sadece ürün listeleme ve raporlama işlemlerine erişim.

## Dosya Yapısı

- `depo.csv`: Ürün bilgilerini saklar.
- `kullanici.csv`: Kullanıcı bilgilerini saklar.
- `log.csv`: Hata ve işlem loglarını saklar.

## Örnek Komutlar

- Yeni bir ürün eklemek için "Ürün Ekle" seçeneğini kullanın ve gerekli bilgileri Zenity formlarında doldurun.
- Ürün güncellemek için ilgili ürün adını girerek yeni stok ve fiyat bilgilerini sağlayın.
- Raporlama için sunulan seçeneklerden birini seçin (ör. "Stokta Azalan Ürünler").

## YouTube Tanıtım Videosu

[Proje Tanıtım Videosu](https://www.youtube.com/watch?v=dummy-link)


## Gereksinimler
- **İşletim Sistemi**: Linux veya Unix tabanlı bir sistem
- **Zenity**: Kullanıcı arayüzü için gerekli
- **Bash**: Komut dosyası için

## Kurulum
1. **Zenity Kurulumu**:
   - Ubuntu/Debian:
     ```bash
     sudo apt-get install zenity
     ```
   - Fedora/RHEL:
     ```bash
     sudo dnf install zenity
     ```
2. **Proje Dosyalarını İndirin**:
   ```bash
   git clone https://github.com/emirrdvn/zenity-management-system
   cd <proje-dizini>
   ```
3. **Çalıştırma İzni Verin**:
   ```bash
   chmod +x envanter_yonetim.sh
   ```

## Kullanım
1. Sistemi çalıştırmak için:
   ```bash
   ./envanter_yonetim.sh
   ```
2. Kullanıcı adı ve parola ile giriş yapın.
3. Menüden istediğiniz işlemi seçin.

## Dosya Yapısı
- **`depo.csv`**: Ürün bilgilerinin saklandığı dosya.
- **`kullanici.csv`**: Kullanıcı bilgilerinin saklandığı dosya.
- **`log.csv`**: Sistem loglarının saklandığı dosya.

## Önemli Notlar
- **Varsayılan Dosya Yapısı**: Script, ilk çalıştırıldığında gerekli CSV dosyalarını otomatik oluşturur.
- **Admin Yetkisi**: `admin` rolüne sahip kullanıcılar tüm özelliklere erişebilirken, diğer kullanıcılar sınırlı erişime sahiptir.
- **Hata Yönetimi**: Hatalar `log.csv` dosyasına kaydedilir ve kullanıcıya bilgi mesajı gösterilir.

## Örnek Akış
1. Kullanıcı giriş yapar.
2. Menüden "Ürün Ekle" seçeneği seçilir.
3. Gerekli bilgiler girilir ve ürün eklenir.
4. "Ürün Listele" ile ürünler görüntülenir.

## Geliştirme ve Katkı
Eğer projeye katkıda bulunmak istiyorsanız, lütfen şu adımları izleyin:
1. Fork yapın.
2. Yeni bir branch oluşturun:
   ```bash
   git checkout -b yeni-ozellik
   ```
3. Değişikliklerinizi yapın ve commit edin.
   ```bash
   git commit -m "Yeni bir özellik eklendi."
   ```
4. Pull Request gönderin.

## Lisans
Bu proje açık kaynaklıdır ve [MIT Lisansı](LICENSE) ile lisanslanmıştır.


