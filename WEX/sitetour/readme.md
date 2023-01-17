Tour işlemleri için wex

Wex Url Pattern: /wex.cfm/tour/{function}

function: insert
input:
{
    help_fuseaction: "sayfanın fuseaction *",
    help_head: "başlık",
    help_fuseaction: "wo-fuseaction",
    help_topic: "kayıt edilen verilerin stringfy json u",
    recorder_name: "kayıt eden",
    recorder_domain: "domain",
    recorder_email: "email"
}
output: başarılı işlem için "Ok" başarısız için "No" döndürür

function: getlist
input:
{
    help_fuseaction: "help içeriğinin listeleneceği fuseaction *"
}
output:
[
    {
        help_id: "id, detay almak için kullanılacak", 
        help_head: "başlık", 
        help_fuseaction: "wo-fuseaction",
        recorder_domain: "domain", 
        recorder_email: "email", 
        recorder_name: "isim"
    },
...
]

function: getitem
input:
{
    help_id: "id - numeric *"
}
output:
{
    help_id: "id bilgi için", 
    help_fuseaction: "fuseaction", 
    help_like_count: "like sayısı", 
    help_topic: "stringfy json alındıktan sonra JSON.parse() ile dönüştürülmeli", 
    help_head: "Başlık", 
    recorder_domain: "domain", 
    recorder_email: "email", 
    recorder_name: "isim"
}