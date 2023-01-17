
<cfdirectory directory="D:\W3CATALYST\documents\content\Image\grafik\logo\customer\" name="dirQuery" action="LIST">

<div class="brand_slider_header">    
    
    <cf_get_lang dictionary_id="64607.1.700 sunucu 5.000'den fazla şirket Workcube ürünlerini kullanıyor!">
</div>
<div class="brand_slider">
    <cfloop query = "dirQuery"> 
        <div class="col-md-4 col-12">                              
            <img alt="<cfoutput>#name#</cfoutput>" src="https://networg.workcube.com/documents/content/Image/grafik/logo/customer/<cfoutput>#name#</cfoutput>" width="150px" height="150px"/>         
        </div>
    </cfloop> 
</div>
     
<script>
    $(function(){
        $('.brand_slider').slick({
            slidesToShow: 5,
            slidesToScroll: 1,
            dots:false,
            speed: 700,
            responsive: 
            [
                {
                breakpoint: 768,
                settings: {
                    slidesToShow: 2
                }
                },
                {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1,
                }
                }
            ]
        });
    })
</script>
