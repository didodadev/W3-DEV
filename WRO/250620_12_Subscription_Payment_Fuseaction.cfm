<!-- Description : Ödeme planı Sayfasi popuptan çıkarıldı, fuseaction değiştirildi..
Developer: Deniz Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'sales.subscription_payment_plan'  WHERE FULL_FUSEACTION = 'sales.popup_subscription_payment_plan'
</querytag>