#!/bin/bash

# Zenity ile Gelişmiş Envanter Yönetim Sistemi

# CSV Dosyalarını Kontrol Etme
initialize_files() {
    touch depo.csv kullanici.csv log.csv
    if [ ! -s depo.csv ]; then
        echo "ID,Adı,Stok,Fiyat,Kategori" > depo.csv
    fi
    if [ ! -s kullanici.csv ]; then
        echo "ID,Adı,Soyadı,Rol,Parola" > kullanici.csv
    fi
    if [ ! -s log.csv ]; then
        echo "Zaman,Hata Mesajı,Kullanıcı" > log.csv
    fi
}

# Kullanıcı Doğrulama
authenticate_user() {
    local username password role
    username=$(zenity --entry --title="Giriş" --text="Kullanıcı Adını Girin:" 2>/dev/null)
    password=$(zenity --password --title="Giriş" 2>/dev/null)

    if grep -q "$username" kullanici.csv; then
        stored_password=$(grep "$username" kullanici.csv | cut -d',' -f5)
        role=$(grep "$username" kullanici.csv | cut -d',' -f4)
        if [ "$password" == "$stored_password" ]; then
            zenity --info --text="Giriş Başarılı! Rol: $role" 2>/dev/null
            main_menu "$role"
        else
            zenity --error --text="Hatalı Parola!" 2>/dev/null
            echo "$(date),Hatalı parola girildi,"$(whoami)"" >> log.csv
        fi
    else
        zenity --error --text="Kullanıcı Bulunamadı!" 2>/dev/null
        echo "$(date),Kullanıcı bulunamadı,"$(whoami)"" >> log.csv
    fi
}

# Ürün Ekleme Fonksiyonu
add_product() {
    local product_info
    product_info=$(zenity --forms --title="Ürün Ekle" \
        --add-entry="Ürün Adı" \
        --add-entry="Stok Miktarı" \
        --add-entry="Birim Fiyatı" \
        --add-entry="Kategori" 2>/dev/null)

    if [ "$?" -eq 0 ]; then
        IFS="|" read -r name stock price category <<< "$product_info"
        if [[ -z "$name" || -z "$stock" || -z "$price" || -z "$category" ]]; then
            zenity --error --text="Tüm alanları doldurun." 2>/dev/null
            echo "$(date),Eksik bilgi girildi,"$(whoami)"" >> log.csv
            return
        fi

        if grep -q "^.*,${name}," depo.csv; then
            zenity --error --text="Bu ürün adıyla başka bir kayıt bulunmaktadır. Lütfen farklı bir ad giriniz." 2>/dev/null
            echo "$(date),Ürün zaten mevcut,"$(whoami)"" >> log.csv
            return
        fi

        new_id=$(tail -n +2 depo.csv | wc -l)
        ((new_id++))
        echo "$new_id,$name,$stock,$price,$category" >> depo.csv
        zenity --info --text="Ürün başarıyla eklendi." 2>/dev/null
    fi
}

# Ürün Listeleme Fonksiyonu
list_products() {
    local inventory
    inventory=$(tail -n +2 depo.csv)

    if [[ -z "$inventory" ]]; then
        zenity --info --text="Envanterde ürün bulunmamaktadır." 2>/dev/null
    else
        zenity --text-info --title="Ürün Listesi" --filename=<(echo "$inventory") --width=800 --height=400 2>/dev/null
    fi
}

# Ürün Güncelleme Fonksiyonu
update_product() {
    local product_name updated_stock updated_price
    product_name=$(zenity --entry --title="Ürün Güncelle" --text="Güncellemek istediğiniz ürün adını giriniz:" 2>/dev/null)

    if grep -q "$product_name" depo.csv; then
        updated_stock=$(zenity --entry --title="Ürün Güncelle" --text="Yeni stok miktarını giriniz:" 2>/dev/null)
        updated_price=$(zenity --entry --title="Ürün Güncelle" --text="Yeni birim fiyatını giriniz:" 2>/dev/null)

        awk -F',' -v name="$product_name" -v stock="$updated_stock" -v price="$updated_price" \
            'BEGIN {OFS=","} {if ($2==name) {$3=stock; $4=price} print}' depo.csv > depo_temp.csv
        mv depo_temp.csv depo.csv

        zenity --info --text="Ürün başarıyla güncellendi." 2>/dev/null
    else
        zenity --error --text="Ürün bulunamadı." 2>/dev/null
        echo "$(date),Ürün bulunamadı,"$(whoami)"" >> log.csv
    fi
}

# Ürün Silme Fonksiyonu
delete_product() {
    local product_name
    product_name=$(zenity --entry --title="Ürün Sil" --text="Silmek istediğiniz ürün adını giriniz:" 2>/dev/null)

    if grep -q "$product_name" depo.csv; then
        zenity --question --title="Onay" --text="Bu ürünü silmek istediğinizden emin misiniz?" 2>/dev/null
        if [ "$?" -eq 0 ]; then
            grep -v "$product_name" depo.csv > depo_temp.csv
            mv depo_temp.csv depo.csv
            zenity --info --text="Ürün başarıyla silindi." 2>/dev/null
        fi
    else
        zenity --error --text="Ürün bulunamadı." 2>/dev/null
        echo "$(date),Ürün bulunamadı,"$(whoami)"" >> log.csv
    fi
}

# Raporlama Fonksiyonu
generate_report() {
    local choice
    choice=$(zenity --list --title="Raporlama" --column="Seçenekler" --width=500 --height=300 \
        "Stokta Azalan Ürünler" "En Yüksek Stok Miktarına Sahip Ürünler" 2>/dev/null)

    case "$choice" in
        "Stokta Azalan Ürünler")
            threshold=$(zenity --entry --title="Raporlama" --text="Eşik değerini girin:" 2>/dev/null)
            awk -F',' -v t="$threshold" 'BEGIN {OFS=","; print "ID,Adı,Stok,Fiyat,Kategori"} NR>1 && $3<t {print}' depo.csv | zenity --text-info --title="Stokta Azalan Ürünler" --width=800 --height=400 2>/dev/null
            ;;
        "En Yüksek Stok Miktarına Sahip Ürünler")
            sort -t',' -k3 -nr depo.csv | head -n 10 | zenity --text-info --title="En Yüksek Stok Miktarına Sahip Ürünler" --width=800 --height=400 2>/dev/null
            ;;
    esac
}

# Kullanıcı Yönetimi
manage_users() {
    local choice
    choice=$(zenity --list --title="Kullanıcı Yönetimi" --column="Seçenekler" --width=500 --height=300 \
        "Yeni Kullanıcı Ekle" "Kullanıcıları Listele" "Kullanıcı Güncelle" "Kullanıcı Sil" 2>/dev/null)

    case "$choice" in
        "Yeni Kullanıcı Ekle")
            user_info=$(zenity --forms --title="Yeni Kullanıcı Ekle" \
                --add-entry="Adı" \
                --add-entry="Soyadı" \
                --add-entry="Rol" \
                --add-password="Parola" 2>/dev/null)
            if [ "$?" -eq 0 ]; then
                IFS="|" read -r first_name last_name role password <<< "$user_info"
                new_id=$(tail -n +2 kullanici.csv | wc -l)
                ((new_id++))
                echo "$new_id,$first_name,$last_name,$role,$password" >> kullanici.csv
                zenity --info --text="Kullanıcı başarıyla eklendi." 2>/dev/null
            fi
            ;;
        "Kullanıcıları Listele")
            zenity --text-info --title="Kullanıcı Listesi" --filename=<(tail -n +2 kullanici.csv) --width=800 --height=400 2>/dev/null
            ;;
        "Kullanıcı Güncelle")
            user_to_update=$(zenity --entry --title="Kullanıcı Güncelle" --text="Güncellemek istediğiniz kullanıcı ID'sini giriniz:" 2>/dev/null)
            if grep -q "^$user_to_update," kullanici.csv; then
                updated_info=$(zenity --forms --title="Kullanıcı Güncelle" \
                    --add-entry="Yeni Adı" \
                    --add-entry="Yeni Soyadı" \
                    --add-entry="Yeni Rol" \
                    --add-password="Yeni Parola" 2>/dev/null)
                if [ "$?" -eq 0 ]; then
                    IFS="|" read -r new_name new_surname new_role new_password <<< "$updated_info"
                    awk -F',' -v id="$user_to_update" -v name="$new_name" -v surname="$new_surname" -v role="$new_role" -v password="$new_password" \
                        'BEGIN {OFS=","} {if ($1==id) {$2=name; $3=surname; $4=role; $5=password} print}' kullanici.csv > kullanici_temp.csv
                    mv kullanici_temp.csv kullanici.csv
                    zenity --info --text="Kullanıcı başarıyla güncellendi." 2>/dev/null
                fi
            else
                zenity --error --text="Kullanıcı bulunamadı." 2>/dev/null
            fi
            ;;
        "Kullanıcı Sil")
            user_to_delete=$(zenity --entry --title="Kullanıcı Sil" --text="Silmek istediğiniz kullanıcı ID'sini giriniz:" 2>/dev/null)
            if grep -q "^$user_to_delete," kullanici.csv; then
                zenity --question --title="Onay" --text="Bu kullanıcıyı silmek istediğinizden emin misiniz?" 2>/dev/null
                if [ "$?" -eq 0 ]; then
                    grep -v "^$user_to_delete," kullanici.csv > kullanici_temp.csv
                    mv kullanici_temp.csv kullanici.csv
                    zenity --info --text="Kullanıcı başarıyla silindi." 2>/dev/null
                fi
            else
                zenity --error --text="Kullanıcı bulunamadı." 2>/dev/null
            fi
            ;;
    esac
}

# Ana Menü
main_menu() {
    local role=$1
    while true; do
        if [ "$role" == "admin" ]; then
            choice=$(zenity --list --title="Ana Menü" --column="Seçenekler" --width=500 --height=400 \
                "Ürün Ekle" "Ürün Listele" "Ürün Güncelle" "Ürün Sil" "Raporlama" "Kullanıcı Yönetimi" "Çıkış" 2>/dev/null)
        else
            choice=$(zenity --list --title="Ana Menü" --column="Seçenekler" --width=500 --height=400 \
                "Ürün Listele" "Raporlama" "Çıkış" 2>/dev/null)
        fi

        case "$choice" in
            "Ürün Ekle") add_product ;;
            "Ürün Listele") list_products ;;
            "Ürün Güncelle") update_product ;;
            "Ürün Sil") delete_product ;;
            "Raporlama") generate_report ;;
            "Kullanıcı Yönetimi") manage_users ;;
            "Çıkış") exit ;;
        esac
    done
}

# Başlangıç Noktası
initialize_files
authenticate_user
