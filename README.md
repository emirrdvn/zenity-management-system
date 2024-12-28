# Zenity ile Gelişmiş Envanter Yönetim Sistemi

## Proje Açıklaması
Bu Bash tabanlı envanter yönetim sistemi, **Zenity** araçlarını kullanarak kullanıcı dostu bir grafik arayüz sağlar. Sistem, ürün yönetimi, kullanıcı yönetimi ve raporlama gibi temel özellikleri içerir. Kullanıcılar, envanterdeki ürünleri ekleyebilir, güncelleyebilir, silebilir ve raporlar oluşturabilir. Ayrıca, kullanıcı yönetimi sayesinde yeni kullanıcılar eklenebilir ve mevcut kullanıcılar üzerinde değişiklik yapılabilir.

## Özellikler
- **Kullanıcı Giriş ve Yetkilendirme**: Kullanıcıların rol bazlı erişim haklarıyla giriş yapması sağlanır.
- **Ürün Yönetimi**:
  - Ürün ekleme
  - Ürün listeleme
  - Ürün güncelleme
  - Ürün silme
- **Raporlama**:
  - Stokta azalan ürünler
  - En yüksek stok miktarına sahip ürünler
- **Kullanıcı Yönetimi**:
  - Yeni kullanıcı ekleme
  - Kullanıcı güncelleme
  - Kullanıcı silme
  - Kullanıcıları listeleme
- **Loglama**: Hata ve olay kayıtlarını `log.csv` dosyasına kaydeder.

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
   git clone <proje-repository-url>
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


