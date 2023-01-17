<cfcomponent displayname="USP">

    <!--- ********************************************************************************************** --->
    <!--- Hint: Before start, add correct default values for arguments currently marked with xxxxxxxxxxx --->
    <!--- ********************************************************************************************** --->
    
    <cffunction name = "init" access= "Public" output = "No" returntype= "Any">
        <!--- UPS Access Settings ---> 
        <cfargument name="License"			type="string" required="No" default="xxxxxxxxxxx" 			hint="UPS License Key" /> 
        <cfargument name="Account"			type="string" required="No" default="xxxxxxxxxxx" 			hint="UPS Account ID" /> 
        <cfargument name="UserId"			type="string" required="No" default="xxxxxxxxxxx" 			hint="UPS UserName" />
        <cfargument name="Password"			type="string" required="No" default="xxxxxxxxxxx" 			hint="UPS Password" />
        <cfargument name="Production"		type="string" required="No" default="No" 					hint="No : Sandbox API, Yes : Production API" /> 
        <cfargument name="LogFolder"		type="string" required="No" default="#ExpandPath('./')#documents/ups/"	hint="The location to store logs" />
        <cfargument name="KeepFullLog"		type="string" required="No" default="Yes" 						hint="Save All Communication in log folder" />
    
        <cfif yesNoFormat(arguments.Production)>
            <cfset settings.apiurl = "https://onlinetools.ups.com/ups.app/xml" />
        <cfelse>
            <cfset settings.apiurl = "https://wwwcie.ups.com/ups.app/xml" />
        </cfif>
        <cfset settings.License     = arguments.License />
        <cfset settings.Account     = arguments.Account />
        <cfset settings.UserId      = arguments.UserId />
        <cfset settings.Password    = arguments.Password />
        <cfset settings.LogFolder   = arguments.LogFolder & '#settings.Account#/'/>
        <cfset settings.KeepFullLog = arguments.KeepFullLog />
        
        <cfif not DirectoryExists("#settings.LogFolder#")>
            <cfdirectory action="create" directory="#settings.LogFolder#">
        </cfif>
        <cfif not DirectoryExists("#settings.LogFolder#Request")>
            <cfdirectory action="create" directory="#settings.LogFolder#Request">
        </cfif>
        <cfif not DirectoryExists("#settings.LogFolder#AcceptReq")>
            <cfdirectory action="create" directory="#settings.LogFolder#AcceptReq">
        </cfif>
        <cfif not DirectoryExists("#settings.LogFolder#Response")>
            <cfdirectory action="create" directory="#settings.LogFolder#Response">
        </cfif>
        <cfif not DirectoryExists("#settings.LogFolder#AcceptResp")>
            <cfdirectory action="create" directory="#settings.LogFolder#AcceptResp">
        </cfif>
        <cfif not DirectoryExists("#settings.LogFolder#Label")>
            <cfdirectory action="create" directory="#settings.LogFolder#Label">
        </cfif>
        <cfif not DirectoryExists("#settings.LogFolder#HighValueReport")>
            <cfdirectory action="create" directory="#settings.LogFolder#HighValueReport">
        </cfif>
        <cfif not DirectoryExists("#settings.LogFolder#VoidRequest")>
            <cfdirectory action="create" directory="#settings.LogFolder#VoidRequest">
        </cfif>
        <cfif not DirectoryExists("#settings.LogFolder#VoidResponse")>
            <cfdirectory action="create" directory="#settings.LogFolder#VoidResponse">
        </cfif>
        <cfreturn this>
    </cffunction>
    
    
    <!--- *********************************************************** --->
    <!--- Create Shipping Label                                       --->
    <!--- *********************************************************** --->
    <cffunction name="shipping" access="remote" returntype="struct" output="Yes">
      <!--- To Address        ---> 
        <cfargument name="Company"			type="string" required="Yes" /> 
        <cfargument name="Name"				type="string" required="Yes" />
        <cfargument name="Address1"			type="string" required="Yes" /> 
        <cfargument name="City"				type="string" required="Yes" /> 
        <cfargument name="State"			type="string" required="Yes" /> 
        <cfargument name="ZIP"				type="string" required="Yes" /> 
        <cfargument name="Phone"			type="string" required="No" default="" />
        <cfargument name="Attention"		type="string" required="No" default="" />
        <cfargument name="Address2"			type="string" required="No" default="" />
        <cfargument name="Address3"			type="string" required="No" default="" />
        <cfargument name="EMailAddress"		type="string" required="No" default="" />
        <cfargument name="Country"			type="string" required="No" default="US" hint="ISO Standard 3166 Country Code" />
        <cfargument name="IsResident"		type="boolean" required="No" default="false" />
        <!--- Service           --->
        <!--- For Complete Code List : Shipping Package XML Developers Guide.pdf - Appendix F - Service Codes --->
        <!--- United States Domestic Shipments                                                                --->
        <!--- 1.UPS Next Day Air / 2.UPS Second Day Air / 3.UPS Ground / 12.UPS Three-Day Select              --->
        <!--- 13.UPS Next Day Air Saver / 14.UPS Next Day Air Early A.M. SM / 59.UPS Second Day Air A.M       --->
        <!--- 65.UPS Saver                                                                                    --->
        <cfargument name="ServiceCode"		type="numeric"	required="No" default="03" hint="01 : UPS Next Day Air, 02 : UPS 2nd Day Air, 03 : UPS Ground, 07 : UPS Worldwide Express, 08 : UPS Worldwide Express Expedited, 11 : UPS Standard, 12 : UPS 3 Day Select, 13 : UPS Next Day Air Saver, 14 : UPS Next Day Air Early A.M., 54 : UPS Worldwide Express Plus, 59 : UPS 2nd Day Air A.M., 65 : UPS Saver" />
        <cfargument name="ServiceDesc"		type="string"	required="No" default="UPS Ground" />
        <!--- package Details   --->
        <cfargument name="pkgType"			type="numeric"	required="No" default="02" hint="01:Letter /02:Custom package /03:Tube /04:PAC /21:UPSexpressBox" />
        <cfargument name="pkgDescription"	type="string"	required="No" default="" />
        <cfargument name="pkgLength"		type="string"	required="No" hint="Inch in US, CM rest of the world" />
        <cfargument name="pkgWidth"			type="string"	required="No" hint="Inch in LB, Kg rest of the world" />
        <cfargument name="pkgHeight"		type="string"	required="No" hint="Inch in US, CM rest of the world" />
        <cfargument name="pkgWeight"		type="string"	required="No" hint="Inch in LB, Kg rest of the world" />
        <cfargument name="InsuranceValue"	type="string"	required="No" hint="In value of [arguments.CurrencyCode]" />
        
        <cfargument name="pkgStruct"		type="struct"	required="No" default=""/>
        
        
        <!--- Services          --->
        <cfargument name="SaturdayDelivery"	type="boolean"	required="No" default="false" hint="Saturday Delivery or not" />
        <cfargument name="VerbConfirmName"	type="string"	required="No" default="" hint="To confirm delivery of your shipment, a UPS representative will call the preferred contact telephone number listed on your UPS Next Day Air® Early A.M.® package." />
        <cfargument name="VerbConfirmPhone"	type="string"	required="No" default="" hint="To confirm delivery of your shipment, a UPS representative will call the preferred contact telephone number listed on your UPS Next Day Air® Early A.M.® package." />
        <!--- Pickup Details    --->
        <cfargument name="SaturdayPickup"	type="boolean"	required="No" default="false"/>
        <cfargument name="PickupDate"		type="string" 	required="No" default="" />
        <cfargument name="PickupTimeEarly"	type="string" 	required="No" default="0800" hint="Earliest Time to Pick Up (HHmm Time Format)" />
        <cfargument name="PickupTimeLate"	type="string" 	required="No" default="1600" hint="Late Time to Pick Up (HHmm Time Format)" />
        <cfargument name="PickupName"		type="string" 	required="No" default="" hint="Name of the person to contact for pickup" />
        <cfargument name="PickupPhone"		type="string" 	required="No" default="" hint="Phone number of the pickup room" />
        <cfargument name="PickupRoom"		type="string" 	required="No" default="" />
        <cfargument name="PickupFloor"		type="string" 	required="No" default="" />
        <cfargument name="PickupLocation"	type="string" 	required="No" default="" />
        <!--- Credit Card Billing - Leave Blank if not in use ---> 	
        <cfargument name="CCNumber"			type="string" required="No" default="" hint="Leave Blank if not in use" />
        <cfargument name="CCType"			type="string" required="No" default="" hint="Leave Blank if not in use" />
        <cfargument name="CCExpirationDate"	type="string" required="No" default="" hint="Leave Blank if not in use" />
        <cfargument name="CCSecurityCode"	type="string" required="No" default="" hint="Leave Blank if not in use" />
        <cfargument name="CCAddress1"		type="string" required="No" default="" hint="Leave Blank if not in use" />
        <cfargument name="CCAddress2"		type="string" required="No" default="" hint="Leave Blank if not in use" />
        <cfargument name="CCAddress3"		type="string" required="No" default="" hint="Leave Blank if not in use" />
        <cfargument name="CCCity"			type="string" required="No" default="" hint="Leave Blank if not in use" /> 
        <cfargument name="CCState"			type="string" required="No" default="" hint="Leave Blank if not in use" /> 
        <cfargument name="CCZIP"			type="string" required="No" default="" hint="Leave Blank if not in use" /> 
        <cfargument name="CCCountry"		type="string" required="No" default="US" hint="Leave Blank if not in use - ISO Standard 3166 Country Code" />
        <!--- Third Party Billing - Leave Blank if not in use --->
        <cfargument name="BillAccount"		type="string" required="No" default="" 		hint="Leave Blank if not in use" />
        <cfargument name="BillZip"			type="string" required="No" default="" 		hint="Leave Blank if not in use" />
        <cfargument name="BillCountry"		type="string" required="No" default="US" 	hint="Leave Blank if not in use - ISO Standard 3166 Country Code" />
    
        <!--- Shipper Address     --->
        <cfargument name="MyCompany"		type="string" required="No" default="#arguments.Company#" />
        <cfargument name="MyName"			type="string" required="No" default="#arguments.Name#" />
        <cfargument name="MyAttention"		type="string" required="No" default=""/>
        <cfargument name="MyAddress1"		type="string" required="No" default="#arguments.Address1#" />
        <cfargument name="MyAddress2"		type="string" required="No" default="" />
        <cfargument name="MyAddress3"		type="string" required="No" default="" />
        <cfargument name="MyCity"			type="string" required="No" default="#arguments.City#" />
        <cfargument name="MyState"			type="string" required="No" default="#arguments.State#" />
        <cfargument name="MyZIP"			type="string" required="No" default="#arguments.Zip#" />
        <cfargument name="MyPhone"			type="string" required="No" default="" />
        <cfargument name="MyEMailAddress"	type="string" required="No" default="" />
        <cfargument name="MyCountry"		type="string" required="No" default="US" hint="ISO Standard 3166 Country Code" />
        <!--- From Address        --->
        <cfargument name="FromCompany"		type="string" required="No" default="#arguments.MyCompany#" />
        <cfargument name="FromName"			type="string" required="No" default="#arguments.MyName#" />
        <cfargument name="FromAttention"	type="string" required="No" default="#arguments.MyAttention#" />
        <cfargument name="FromAddress1"		type="string" required="No" default="#arguments.MyAddress1#" />
        <cfargument name="FromAddress2"		type="string" required="No" default="#arguments.MyAddress2#" />
        <cfargument name="FromAddress3"		type="string" required="No" default="#arguments.MyAddress3#" />
        <cfargument name="FromCity"			type="string" required="No" default="#arguments.MyCity#" />
        <cfargument name="FromState"		type="string" required="No" default="#arguments.MyState#" />
        <cfargument name="FromZIP"			type="string" required="No" default="#arguments.MyZIP#" />
        <cfargument name="FromPhone"		type="string" required="No" default="#arguments.MyPhone#" />
        <cfargument name="FromEMailAddress"	type="string" required="No" default="#arguments.MyEMailAddress#" />
        <cfargument name="FromCountry"		type="string" required="No" default="#arguments.MyCountry#" hint="ISO Standard 3166 Country Code" />
        <!--- Notification (From) Settings    --->
        <cfargument name="NotifyFromEmail"		type="string" required="No" default="" hint="From Email Address for Notifications" />
        <cfargument name="NotifyFromName"		type="string" required="No" default="" hint="From Name for Notifications" />
        <cfargument name="UndeliEmail"			type="string" required="No" default="" hint="Email Address to notify Undeliverable" />
        <!--- Shipment Notification           --->
        <cfargument name="ShipNotifyEmail"		type="string" required="No" default="" hint="Shipment Notification to Email" />
        <cfargument name="ShipNotifyMemo"		type="string" required="No" default="" hint="Shipment Notification to Email Memo" />
        <cfargument name="ShipNotifySubject"	type="string" required="No" default="" hint="Shipment Notification Email Subject" />
        <!--- Delivery Notification           --->
        <cfargument name="DelivNotifyEmail"		type="string" required="No" default="" hint="Delivery Notification to Email" />
        <cfargument name="DelivNotifyMemo"		type="string" required="No" default="" hint="Delivery Notification Email Memo" />
        <cfargument name="DelivNotifySubject"	type="string" required="No" default="" hint="Delivery Notification Email Subject" />
        <!--- Return Notification             --->
        <cfargument name="RetnNotifyEmail"		type="string" required="No" default="" hint="Return Notification to Email - Return Notification (valid for shipment with UPS 1-Attempt and UPS 3-Attempt Return Services)" />
        <cfargument name="RetnNotifyMemo"		type="string" required="No" default="" hint="Return Notification Email Memo" />
        <cfargument name="RetnNotifySubject"	type="string" required="No" default="" hint="Return Notification Email Subject" />
        <!--- Optional/General Settings       ---> 
        <cfargument name="CurrencyCode"	type="string" required="No" default="USD" 	hint="ISO Standard 4217 Currency Codes" />
        <cfargument name="comment"		type="string" required="No" default="" />
        <cfargument name="validate"		type="string" required="No" default="nonvalidate"	hint="(nonvalidate/validate) validate shipping address" />
        <cfargument name="RefCode"		type="string" required="No" default="" 		hint="Supplied by the customer. Can use for Tracking." />
        <cfargument name="RefValue"		type="string" required="No" default="" 		hint="Supplied by the customer. Can use for Tracking." />
        <cfargument name="OrderID"		type="string" required="No" default="#CreateUUID()#" hint="Log files will created under OrderID" />
        
        <cfset local.out	= StructNew()>
    
    <!--- *********************************************************** --->
    <!--- Ship Confirmation Request                                   --->
    <!--- *********************************************************** --->
    <cfsavecontent variable="local.reqxml">
    <cfoutput>
        <?xml version="1.0"?>
        <!--- ************************************************* --->
        <!--- Authentication                                    --->
        <!--- ************************************************* --->
        <AccessRequest xml:lang='en-US'>
            <AccessLicenseNumber>#settings.License#</AccessLicenseNumber>
            <UserId>#settings.UserId#</UserId>
            <Password>#settings.Password#</Password>
        </AccessRequest>
        <?xml version="1.0" ?>
        <ShipmentConfirmRequest>
            <Request>
                <TransactionReference>
                    <CustomerContext>#arguments.comment#</CustomerContext>
                    <XpciVersion>1.0001</XpciVersion>
                </TransactionReference>
                <!--- Must be ShipConfirm --->
                <RequestAction>ShipConfirm</RequestAction>
                <!---  (nonvalidate provides address validation error message, if occurred. validate throw and general error message.) --->
                <RequestOption>#lcase(arguments.validate)#</RequestOption>
            </Request>
            <!--- ************************************************* --->
            <!--- Shipment Information                              --->
            <!--- ************************************************* --->
            <Shipment>
                <Shipper>
                    <Name><![CDATA[#arguments.MyName#]]></Name>
                    <cfif len(trim(arguments.MyAttention))><AttentionName><![CDATA[#arguments.MyAttention#]]></AttentionName></cfif>
                    <cfif len(trim(arguments.MyPhone))><PhoneNumber>#arguments.MyPhone#</PhoneNumber></cfif>
                    <cfif len(trim(arguments.MyEMailAddress))><EMailAddress>#arguments.MyEMailAddress#</EMailAddress></cfif>
                    <ShipperNumber>#settings.Account#</ShipperNumber>
                    <Address>
                        <AddressLine1><![CDATA[#arguments.MyAddress1#]]></AddressLine1>
                        <cfif len(trim(arguments.MyAddress2))><AddressLine2>#arguments.MyAddress2#</AddressLine2></cfif>
                        <cfif len(trim(arguments.MyAddress3))><AddressLine3>#arguments.MyAddress3#</AddressLine3></cfif>
                        <City>#arguments.MyCity#</City>
                        <StateProvinceCode>#arguments.MyState#</StateProvinceCode>
                        <CountryCode>#arguments.MyCountry#</CountryCode>
                        <PostalCode>#arguments.MyZIP#</PostalCode>
                    </Address>
                </Shipper>
                <ShipTo>
                    <CompanyName><![CDATA[#arguments.Company#]]></CompanyName>
                    <AttentionName><![CDATA[#arguments.Attention#]]></AttentionName>
                    <cfif len(trim(arguments.Phone))><PhoneNumber>#arguments.Phone#</PhoneNumber></cfif>
                    <cfif len(trim(arguments.EMailAddress))><EMailAddress>#arguments.EMailAddress#</EMailAddress></cfif>
                    <Address>
                        <AddressLine1><![CDATA[#arguments.Address1#]]></AddressLine1>
                        <cfif len(trim(arguments.Address2))><AddressLine2>#arguments.Address2#</AddressLine2></cfif>
                        <cfif len(trim(arguments.Address3))><AddressLine3>#arguments.Address3#</AddressLine3></cfif>
                        <City>#arguments.City#</City>
                        <StateProvinceCode>#arguments.State#</StateProvinceCode>
                        <CountryCode>#arguments.Country#</CountryCode>
                        <PostalCode>#arguments.ZIP#</PostalCode>
                        <cfif YesNoFormat(arguments.IsResident)><ResidentialAddress>1</ResidentialAddress></cfif>
                    </Address>
                </ShipTo>
                <ShipFrom>
                    <CompanyName><![CDATA[#arguments.FromCompany#]]></CompanyName>
                    <Name><![CDATA[#arguments.FromName#]]></Name>
                    <cfif len(trim(arguments.FromAttention))><AttentionName><![CDATA[#arguments.FromAttention#]]></AttentionName></cfif>
                    <cfif len(trim(arguments.FromPhone))><PhoneNumber>#arguments.FromPhone#</PhoneNumber></cfif>
                    <cfif len(trim(arguments.FromEMailAddress))><EMailAddress>#arguments.FromEMailAddress#</EMailAddress></cfif>
                    <Address>
                        <AddressLine1><cfif len(arguments.FromAddress1)><![CDATA[#arguments.FromAddress1#]]><cfelse><![CDATA[#arguments.MyAddress1#]]></cfif></AddressLine1>
                        <cfif len(trim(arguments.FromAddress2))><AddressLine2>#arguments.FromAddress2#</AddressLine2></cfif>
                        <cfif len(trim(arguments.FromAddress3))><AddressLine3>#arguments.FromAddress3#</AddressLine3></cfif>
                        <City><cfif len(arguments.FromCity)>#arguments.FromCity#<cfelse>#arguments.MyCity#</cfif></City>
                        <StateProvinceCode><cfif len(arguments.FromState)>#arguments.FromState#<cfelse>#arguments.MyState#</cfif></StateProvinceCode>
                        <CountryCode><cfif len(arguments.FromCountry)>#arguments.FromCountry#<cfelse>#arguments.MyCountry#</cfif></CountryCode>
                        <PostalCode><cfif len(arguments.FromZIP)>#arguments.FromZIP#<cfelse>#arguments.MyZIP#</cfif></PostalCode>
                    </Address>
                </ShipFrom>
                <Service>
                    <Code>#arguments.ServiceCode#</Code>
                    <Description>#arguments.ServiceDesc#</Description>
                </Service>
                <PaymentInformation>
                    <cfif not len(trim(arguments.BillAccount))>
                        <Prepaid>
                            <BillShipper>
                                <AccountNumber>#settings.Account#</AccountNumber>
                                <cfif len(trim(arguments.CCNumber))>
                                <CreditCard>
                                    <Type>#arguments.CCType#</Type>
                                    <Number>#arguments.CCNumber#</Number>
                                    <ExpirationDate>#arguments.CCExpirationDate#</ExpirationDate>
                                    <SecurityCode>#arguments.CCSecurityCode#</SecurityCode>
                                    <Address>
                                        <AddressLine1>#arguments.CCAddress1#</AddressLine1>
                                        <cfif len(trim(arguments.CCAddress2))><AddressLine2>#arguments.CCAddress2#</AddressLine2></cfif>
                                        <cfif len(trim(arguments.CCAddress3))><AddressLine3>#arguments.CCAddress3#</AddressLine3></cfif>
                                        <City>#arguments.CCCity#</City>
                                        <StateProvinceCode>#arguments.CCState#</StateProvinceCode>
                                        <CountryCode>#arguments.CCCountry#</CountryCode>
                                        <PostalCode>#arguments.CCZIP#</PostalCode>
                                    </Address>
                                </CreditCard>
                                </cfif>
                            </BillShipper>
                        </Prepaid>
                    </cfif>
                    <cfif len(trim(arguments.BillAccount))>
                        <BillThirdParty>
                            <BillThirdPartyShipper>
                                <AccountNumber>#arguments.BillAccount#</AccountNumber>
                                <ThirdParty>
                                    <Address>
                                        <PostalCode>#arguments.BillZip#</PostalCode>
                                        <CountryCode>#arguments.BillCountry#</CountryCode>
                                    </Address>
                                </ThirdParty>
                            </BillThirdPartyShipper>
                        </BillThirdParty>
                    </cfif>
                </PaymentInformation>
                <ShipmentServiceOptions>
                    <cfif YesNoFormat(arguments.SaturdayPickup)><SaturdayPickup>1</SaturdayPickup></cfif>
                    <cfif YesNoFormat(arguments.SaturdayDelivery)><SaturdayDelivery>1</SaturdayDelivery></cfif>
                    <cfif IsDate(arguments.PickupDate)>
                    <OnCallAir>
                        <PickupDetails>
                            <!---YYYYMMDD ---->
                            <PickupDate>#DateFormat(arguments.PickupDate,'YYYYMMDD')#</PickupDate>
                            <cfif len(trim(arguments.PickupTimeEarly))><EarliestTimeReady>#replace(replace(arguments.PickupTimeEarly,':',"",'all'),' ',"",'all')#</EarliestTimeReady></cfif>
                            <cfif len(trim(arguments.PickupTimeLate))><LatestTimeReady>#replace(replace(arguments.PickupTimeLate,':',"",'all'),' ',"",'all')#</LatestTimeReady></cfif>
                            <cfif len(trim(arguments.PickupRoom))><SuiteRoomID>#arguments.PickupRoom#</SuiteRoomID></cfif>
                            <cfif len(trim(arguments.PickupFloor))><FloorID>#arguments.PickupFloor#</FloorID></cfif>
                            <cfif len(trim(arguments.PickupLocation))><Location>#arguments.PickupLocation#</Location></cfif>
                            <cfif len(trim(arguments.PickupName))>
                            <ContactInfo>
                                <Name>#arguments.PickupName#</Name>
                                <PhoneNumber>#arguments.PickupPhone#</PhoneNumber>
                            </ContactInfo>
                            </cfif>
                        </PickupDetails>
                    </OnCallAir>
                    </cfif>
                    <cfif len(trim(arguments.ShipNotifyEmail))>
                    <Notification>
                        <NotificationCode>6</NotificationCode>
                        <EMailMessage>
                            <EMailAddress>#arguments.ShipNotifyEmail#</EMailAddress>
                            <UndeliverableEMailAddress>#arguments.UndeliEmail#</UndeliverableEMailAddress>
                            <FromEMailAddress>#arguments.NotifyFromEmail#</EMailAddress>
                            <FromName>#arguments.NotifyFromName#</FromName>
                            <Memo>#arguments.ShipNotifyMemo#</Memo>
                            <Subject>#arguments.ShipNotifySubject#</Subject>
                        </EMailMessage>
                    </Notification>
                    </cfif>
                    <cfif len(trim(arguments.DelivNotifyEmail))>
                    <Notification>
                        <NotificationCode>8</NotificationCode>
                        <EMailMessage>
                            <EMailAddress>#arguments.DelivNotifyEmail#</EMailAddress>
                            <UndeliverableEMailAddress>#arguments.UndeliEmail#</UndeliverableEMailAddress>
                            <FromEMailAddress>#arguments.NotifyFromEmail#</FromEMailAddress>
                            <FromName>#arguments.NotifyFromName#</FromName>
                            <Memo>#arguments.DelivNotifyMemo#</Memo>
                            <Subject>#arguments.DelivNotifySubject#</Subject>
                        </EMailMessage>
                    </Notification>
                    </cfif>
                    <cfif len(trim(arguments.RetnNotifyEmail))>
                    <Notification>
                        <NotificationCode>8</NotificationCode>
                        <EMailMessage>
                            <EMailAddress>#arguments.RetnNotifyEmail#</EMailAddress>
                            <UndeliverableEMailAddress>#arguments.UndeliEmail#</UndeliverableEMailAddress>
                            <FromEMailAddress>#arguments.NotifyFromEmail#</FromEMailAddress>
                            <FromName>#arguments.NotifyFromName#</FromName>
                            <Memo>#arguments.RetnNotifyMemo#</Memo>
                            <Subject>#arguments.RetnNotifySubject#</Subject>
                        </EMailMessage>
                    </Notification>
                    </cfif>
                </ShipmentServiceOptions>
                <!--- can add multiple package --->
                <cfset pcks = arguments.pkgStruct>
                <cfset pck_count = arraylen(pcks.pck)>
                <cfloop from="1" to="#pck_count#" index="row_">
                    <cfset l_ = pcks.pck[row_].pkgLength>
                    <cfset w_ = pcks.pck[row_].pkgWidth>
                    <cfset h_ = pcks.pck[row_].pkgHeight>				
                    <cfset weight_ = pcks.pck[row_].pkgWeight>
                    
                    <Package>
                        <cfif len(trim(arguments.pkgDescription))><Description>#arguments.pkgDescription#</Description></cfif>
                        <PackagingType>
                            <Code>#NumberFormat(val(arguments.pkgType),'09')#</Code>
                            <cfswitch expression="#NumberFormat(val(arguments.pkgType),'09')#">
                                <cfcase value="1"><Description>Letter</Description></cfcase>
                                <cfcase value="2"><Description>Custom package</Description></cfcase>
                                <cfcase value="3"><Description>Tube</Description></cfcase>
                                <cfcase value="4"><Description>PAC</Description></cfcase>
                                <cfcase value="21"><Description>UPSexpressBox</Description></cfcase>
                            </cfswitch>
                        </PackagingType>
                        <Dimensions>
                            <UnitOfMeasurement>
                                <Code><cfswitch expression="#trim(arguments.MyCountry)#"><cfcase value="US">IN</cfcase><cfdefaultcase>CM</cfdefaultcase></cfswitch></Code>
                            </UnitOfMeasurement>
                            <Length>#l_#</Length>
                            <Width>#w_#</Width>
                            <Height>#h_#</Height>
                        </Dimensions>
                        <PackageWeight>
                            <UnitOfMeasurement> 
                                <Code><cfswitch expression="#trim(arguments.MyCountry)#"><cfcase value="US">LBS</cfcase><cfdefaultcase>KGS</cfdefaultcase></cfswitch></Code>
                            </UnitOfMeasurement>
                            <Weight>#weight_#</Weight>
                        </PackageWeight>
                        <cfif len(trim(arguments.RefCode))>
                        <ReferenceNumber>
                            <Code>#arguments.RefCode#</Code>
                            <Value>#arguments.RefValue#</Value>
                        </ReferenceNumber>
                        </cfif>
                        <PackageServiceOptions>
                            <InsuredValue>
                                <CurrencyCode>#arguments.CurrencyCode#</CurrencyCode>
                                <MonetaryValue>#arguments.InsuranceValue#</MonetaryValue>
                            </InsuredValue>
                        <cfif len(trim(arguments.VerbConfirmPhone))>	
                            <VerbalConfirmation>
                                <Name>#arguments.VerbConfirmName#</Name>
                                <PhoneNumber>#arguments.VerbConfirmPhone#</PhoneNumber>
                            </VerbalConfirmation>
                        </cfif>
                        </PackageServiceOptions>
                    </Package>
                </cfloop>
            </Shipment>
            <LabelSpecification>
                <LabelPrintMethod>
                    <Code>GIF</Code>
                </LabelPrintMethod>
                <HTTPUserAgent>Mozilla/4.5</HTTPUserAgent>
                <LabelImageFormat> <Code>GIF</Code> </LabelImageFormat>
            </LabelSpecification>
        </ShipmentConfirmRequest>
    </cfoutput>
    </cfsavecontent>
    
    <!--- *********************************************************** --->
    <!--- Save the Request Log file                                   --->
    <!--- *********************************************************** --->
    <cfif YesNoFormat(settings.KeepFullLog)>
        <cffile action="write" output="#local.reqxml#" file="#settings.LogFolder#Request/#arguments.orderid#.xml">
    </cfif>
    
    <!--- *********************************************************** --->
    <!--- Send Request to UPS                                         --->
    <!--- *********************************************************** --->
    <cftry>
    <cfhttp url="#settings.apiurl#/ShipConfirm" method="post" result="local.result">
        <cfhttpparam type="xml" name="data" value="#local.reqxml#">
    </cfhttp>
        <cfcatch>
            <cfset local.out.message = "UPS Connection Failed">
        </cfcatch>
    </cftry>
    
    <cfset local.result = XMLParse(local.result.Filecontent)>
    
    <cfif local.result.ShipmentConfirmResponse.Response.ResponseStatusDescription.XmlText eq 'Success'>
        <!--- *********************************************************** --->
        <!--- Save the Response Log file                                  --->
        <!--- *********************************************************** --->
        <cfif YesNoFormat(settings.KeepFullLog)>
            <cffile action="write" output="#local.result#" file="#settings.LogFolder#Response/#arguments.orderid#.xml">
        </cfif>
    
        <cfset local.out.code = "1">
        <cfset local.out.message = "Success">
        <cfset local.out.TransportationCharges			= local.result.ShipmentConfirmResponse.ShipmentCharges.TransportationCharges.MonetaryValue.XmlText>
        <cfset local.out.ServiceOptionsCharges			= local.result.ShipmentConfirmResponse.ShipmentCharges.ServiceOptionsCharges.MonetaryValue.XmlText>
        <cfset local.out.TotalCharges					= local.result.ShipmentConfirmResponse.ShipmentCharges.TotalCharges.MonetaryValue.XmlText>
        <cfset local.out.BillingWeight					= local.result.ShipmentConfirmResponse.BillingWeight.Weight.XmlText>
        <cfset local.out.ShipmentDigest					= local.result.ShipmentConfirmResponse.ShipmentDigest.XmlText>
        <cfset local.out.ShipmentIdentificationNumber	= local.result.ShipmentConfirmResponse.ShipmentIdentificationNumber.XmlText>
    
        <!--- *********************************************************** --->
        <!--- Ship Confirmation Request                                   --->
        <!--- *********************************************************** --->
        <cfsavecontent variable="local.reqxml">
        <cfoutput>
            <?xml version="1.0"?>
            <AccessRequest xml:lang='en-US'>
                <AccessLicenseNumber>#settings.License#</AccessLicenseNumber>
                <UserId>#settings.UserId#</UserId>
                <Password>#settings.Password#</Password>
            </AccessRequest>
            <?xml version="1.0" ?>
            <ShipmentAcceptRequest>
                <Request>
                    <TransactionReference>
                        <CustomerContext>#local.out.ShipmentDigest#</CustomerContext>
                        <XpciVersion>1.0001</XpciVersion>
                    </TransactionReference>
                    <RequestAction>ShipAccept</RequestAction>
                </Request>
                <ShipmentDigest>#local.out.ShipmentDigest#</ShipmentDigest>
            </ShipmentAcceptRequest>
        </cfoutput>
        </cfsavecontent>
    
        <!--- *********************************************************** --->
        <!--- Save Shipping Acceptance Request Log file                   --->
        <!--- *********************************************************** --->
        <cfif YesNoFormat(settings.KeepFullLog)>
            <cffile action="write" output="#local.reqxml#" file="#settings.LogFolder#AcceptReq/#arguments.orderid#.xml">
        </cfif>
    
        <!--- *********************************************************** --->
        <!--- Send Acceptance Request to UPS and collect the Label        --->
        <!--- *********************************************************** --->
        <cfhttp url="#settings.apiurl#/ShipAccept" method="post" result="local.result">
            <cfhttpparam type="xml" name="data" value="#local.reqxml#">
        </cfhttp>
        <cfset local.result = XMLParse(local.result.Filecontent)>
    
        <!--- *********************************************************** --->
        <!--- Save Shipping Acceptance Response Log file                  --->
        <!--- *********************************************************** --->
        <cfif YesNoFormat(settings.KeepFullLog)>
            <cffile action="write" output="#local.result#" file="#settings.LogFolder#AcceptResp/#arguments.orderid#.xml">
        </cfif>
        
        <!--- *********************************************************** --->
        <!--- Save the label                                              --->
        <!--- *********************************************************** --->
        
    
        <cfif local.result.ShipmentAcceptResponse.Response.ResponseStatusDescription.XmlText eq 'Success'>
        
            <cfset label_count_ = arraylen(local.result.ShipmentAcceptResponse.ShipmentResults.PackageResults)>
            <cfset t_number = "">
            
            <cfloop from="1" to="#label_count_#" index="row">
                <cfset t_number_row	= local.result.ShipmentAcceptResponse.ShipmentResults.PackageResults[row].TrackingNumber.XmlText>
                <cffile action	="write"
                    charset		="utf-8"
                    file		="#settings.LogFolder#Label\label#t_number_row#.gif"
                    output		="#ToBinary(local.result.ShipmentAcceptResponse.ShipmentResults.PackageResults[row].LabelImage.GraphicImage.XmlText)#">
                    
                <cffile action	="write"
                    charset		="utf-8"
                    file		="#settings.LogFolder#Label\#arguments.orderid#_#row#.html"
                    output		="#ToBinary(local.result.ShipmentAcceptResponse.ShipmentResults.PackageResults[row].LabelImage.HTMLImage.XmlText)#">
    
                <cfset t_number = listappend(t_number,t_number_row)>
            </cfloop>
            
            <cfset local.out.TrackingNumber	= t_number>
                
        <!--- *********************************************************** --->
        <!--- Save High Value Report                                      --->
        <!--- *********************************************************** --->
            <cfif IsDefined('local.result.ShipmentAcceptResponse.ShipmentResults.ControlLogReceipt.GraphicImage')>
                <cffile action	="write"
                    charset		="utf-8"
                    file		="#settings.LogFolder#HighValueReport\#arguments.orderid#.html"
                    output		="#ToBinary(local.result.ShipmentAcceptResponse.ShipmentResults.ControlLogReceipt.GraphicImage.XmlText)#">
            </cfif>
        <cfelse>
            <cfset local.out.message = "Shipment Acceptance Request Failed">
        </cfif>
    <cfelse>
        <!--- *********************************************************** --->
        <!--- Request Failure                                             --->
        <!--- *********************************************************** --->
        <cfif IsDefined('local.result.ShipmentConfirmResponse.Response.Error.ErrorDescription.XmlText')>
            <cfset local.out.message = local.result.ShipmentConfirmResponse.Response.Error.ErrorDescription.XmlText>
        <cfelse>
            <cfset local.out.message = "Failure">
        </cfif>
        <cfset local.out.code = "0">
        <cfset local.out.TrackingNumber = "">
    </cfif>
        <cfreturn local.out>
    </cffunction>
    
    <!--- *********************************************************** --->
    <!--- Void Shipping Label                                         --->
    <!--- *********************************************************** --->
    <cffunction name="void" access="remote" returntype="string" output="Yes">
        <cfargument name="Identification"	type="string" required="Yes" />
        <cfargument name="Tracking"			type="string" required="No" default="" />
        
        <cfset var local	= StructNew()>
        <cfset local.out	= "Successful">
        <!--- *********************************************************** --->
        <!--- Ship Void Request                                           --->
        <!--- *********************************************************** --->
        <cfsavecontent variable="local.reqxml">
        <cfoutput>
            <?xml version="1.0" encoding="UTF-8"?>
            <AccessRequest xml:lang="en-US">
                <AccessLicenseNumber>#settings.License#</AccessLicenseNumber>
                <UserId>#settings.UserId#</UserId>
                <Password>#settings.Password#</Password>
            </AccessRequest>
            <?xml version="1.0" ?>
            <VoidShipmentRequest>
            <Request>
                <TransactionReference>
                    <CustomerContext>Void shipment #arguments.Identification#</CustomerContext>
                    <XpciVersion>1.0</XpciVersion>
                </TransactionReference>
                <RequestAction>1</RequestAction>
                <RequestOption>1</RequestOption>
            </Request>
            <cfif len(trim(arguments.Tracking))>
            <ExpandedVoidShipment>
                <shipmentidentificationnumber>#ucase(arguments.Identification)#</shipmentidentificationnumber>
                <cfloop list="#arguments.Tracking#" index="i"><trackingnumber>#ucase(i)#</trackingnumber></cfloop>
            </ExpandedVoidShipment>
            </cfif>
            <ShipmentIdentificationNumber>#ucase(arguments.Identification)#</ShipmentIdentificationNumber>
            </VoidShipmentRequest>
        </cfoutput>
        </cfsavecontent>
    
        <!--- *********************************************************** --->
        <!--- Save the Request Log file                                   --->
        <!--- *********************************************************** --->
        <cfif YesNoFormat(settings.KeepFullLog)>
            <cffile action="write" output="#local.reqxml#" file="#settings.LogFolder#VoidRequest/#arguments.Identification#.xml">
        </cfif>
    
        <cftry>
        <!--- *********************************************************** --->
        <!--- Send Void Request to UPS and collect the Label              --->
        <!--- *********************************************************** --->
        <cfhttp url="#settings.apiurl#/Void" method="post" result="local.result">
            <cfhttpparam type="xml" name="data" value="#local.reqxml#">
        </cfhttp>
        <cfset local.result = XMLParse(local.result.Filecontent)>
    
        <!--- *********************************************************** --->
        <!--- Save the Response Log file                                  --->
        <!--- *********************************************************** --->
        <cfif YesNoFormat(settings.KeepFullLog)>
            <cffile action="write" output="#local.result#" file="#settings.LogFolder#VoidResponse/#arguments.Identification#.xml">
        </cfif>
            <cfcatch>
                <cfset local.out	= "Error">
            </cfcatch>
        </cftry>
    
        <cfreturn local.out>
    </cffunction>
    
    </cfcomponent>