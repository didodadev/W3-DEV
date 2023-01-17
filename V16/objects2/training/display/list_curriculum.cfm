<cfset METHODS = createObject('component','V16.objects2.cfc.widget.training')>
<cfset GET_TRAININGS_CURRICULUM = METHODS.GET_TRAININGS_CURRICULUM(site: GET_PAGE.PROTEIN_SITE)>

<div class="syllabus">
    
    <!--- Bu kısım içerik detay widgeti kullanılarak İçerik yönetim sistemi içinden girebilir hale getirildi. 
        Çok dilli kullanım için --->

    <!--- <h1>DİJİTAL KASLARI GÜÇLENDİREN EĞİTİM VE SERTİFİKA PROGRAMLARI</h1>
    <p>Workcube eğitimleri Workcube Topluluğu ve Holistic Bilgi Teknolojileri Kooperatifi'nin 
        ortak geliştirdiği kurumların ve kişilerin dijital olgunluk düzeyini 
        yükseltmek amacıyla tasarlanmıştır.</p> --->
        <!--- <div class="syllabus_icon">
            <img src="/src/assets/icons/catalyst-icon-svg/academy-logo.svg" width="148px" height="121px">
        </div>
    <h3>Kurslar / Sertifikalar</h3>   --->
    <div class="syllabus_box">
        <cfoutput query="GET_TRAININGS_CURRICULUM">            
            <a href="/#USER_FRIENDLY_URL#">
                <div class="syllabus_box_item">
                    <img src="/documents/train_subject/#PATH#">
                    <div class="syllabus_box_item_txt">
                        #train_head#
                    </div>            
                </div>
            </a>
        </cfoutput>
    </div>
</div> 

<script>
    var myColors = [
    '#F37179','#808080', '#3C9CD8', '#5BBD72', '#FBB158', '#BD60A6','#F68D6F','#42C7C6','#CEA683'
    ];
    var i = 0;
    $('.syllabus_box_item').each(function() {
        $(this).css('background-color', myColors[i]);
        i = (i + 1) % myColors.length;
    });
</script>