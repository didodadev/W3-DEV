<!---
    Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
    Date: 09.12.2020
    Description:
	Satınalma siparişinde aşamaya göre siparişin işlem tipinin güncellenmesi. (display file)
--->
<script type="text/javascript">
    function selectDisabled(){
            var $dropDown = $('#process_cat') , 
                name = $dropDown.prop('name') , 
                $form = $dropDown.parent();

                $dropDown.data('original-name',name);  
                
                var $hiddenInput = $('<input/>' , {type : 'hidden' , name: name , value:$dropDown.val() });
                $form.append( $hiddenInput );  
                $dropDown.addClass('disabled')  //disable class
                     .prop({'name' : name + "_1" , disabled : true}); 
    }
    function process_cat_dsp_function()
    {   
        if (document.getElementById("process_stage").value == 336 ) {/*aşama Bütçe Onay ise  */
            $("#process_cat").val(190);/* işlem tipi Bütçe Rezerve olsun ve değiştirilemez */
            /* var $hiddenInput = $('<input/>' , {type : 'hidden' , name: 'process_cat' , value:'190' });   
            $("#process_cat").after( $hiddenInput ); 
            $("#process_cat").attr("disabled", true); */
            selectDisabled();
              
        }
        else if (document.getElementById("process_stage").value == 335 || document.getElementById("process_stage").value == 42 || document.getElementById("process_stage").value == 92)
        {/* aşama Bütçe Kontrol veya Kayıt veya Red ise  */
            $("#process_cat").val(180);/* işlem tipi Satınalma olsun ve değiştirilemez*/
            /* var $hiddenInput = $('<input/>' , {type : 'hidden' , name: 'process_cat' , value:'180' });   
            $("#process_cat").after( $hiddenInput ); 
            $("#process_cat").attr("disabled", true); */
            selectDisabled();
        }
    }
</script>