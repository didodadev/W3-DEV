<!--Description : İller datalarını ekleyen scripttir.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 1 FROM @_dsn_main_@.SETUP_CITY)
    BEGIN
        SET IDENTITY_INSERT [SETUP_CITY] ON 
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (1, N'ADANA', N'322', N'01', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (2, N'ADIYAMAN', N'416', N'02', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (3, N'AFYON', N'272', N'03', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (4, N'AĞRI', N'472', N'04', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (5, N'AKSARAY', N'382', N'68', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (6, N'AMASYA', N'358', N'05', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (7, N'ANKARA', N'312', N'06', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (8, N'ANTALYA', N'242', N'07', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (9, N'ARDAHAN', N'478', N'75', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (10, N'ARTVİN', N'466', N'08', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (11, N'AYDIN', N'256', N'09', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (12, N'BALIKESİR', N'266', N'10', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (13, N'BARTIN', N'378', N'74', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (14, N'BATMAN', N'488', N'72', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (15, N'BAYBURT', N'458', N'69', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (16, N'BİLECİK', N'228', N'11', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (17, N'BİNGÖL', N'426', N'12', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (18, N'BİTLİS', N'434', N'13', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (19, N'BOLU', N'374', N'14', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (20, N'BURDUR', N'248', N'15', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (21, N'BURSA', N'224', N'16', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (22, N'ÇANAKKALE', N'286', N'17', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (23, N'ÇANKIRI', N'376', N'18', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (24, N'ÇORUM', N'364', N'19', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (25, N'DENİZLİ', N'258', N'20', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (26, N'DİYARBAKIR', N'412', N'21', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (27, N'DÜZCE', N'380', N'81', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (28, N'EDİRNE', N'284', N'22', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (29, N'ELAZIĞ', N'424', N'23', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (30, N'ERZİNCAN', N'446', N'24', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (31, N'ERZURUM', N'442', N'25', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (32, N'ESKİŞEHİR', N'222', N'26', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (33, N'GAZİANTEP', N'342', N'27', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (34, N'GİRESUN', N'454', N'28', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (35, N'GÜMÜŞHANE', N'456', N'29', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (36, N'HAKKARİ', N'438', N'30', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (37, N'HATAY', N'326', N'31', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (38, N'IĞDIR', N'476', N'76', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (39, N'ISPARTA', N'246', N'32', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (40, N'İSTANBUL(Anadolu)', N'216', N'34', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (41, N'İSTANBUL(Avrupa)', N'212', N'34', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (42, N'İZMİR', N'232', N'35', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (43, N'KAHRAMANMARAŞ', N'344', N'46', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (44, N'KARABÜK', N'370', N'78', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (45, N'KARAMAN', N'338', N'70', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (46, N'KARS', N'474', N'36', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (47, N'KASTAMONU', N'366', N'37', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (48, N'KAYSERİ', N'352', N'38', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (49, N'KIRIKKALE', N'318', N'71', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (50, N'KIRKLARELİ', N'288', N'39', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (51, N'KIRŞEHİR', N'386', N'40', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (52, N'KİLİS', N'348', N'79', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (53, N'KOCAELİ', N'262', N'41', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (54, N'KONYA', N'332', N'42', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (55, N'KÜTAHYA', N'274', N'43', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (56, N'MALATYA', N'422', N'44', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (57, N'MANİSA', N'236', N'45', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (58, N'MARDİN', N'482', N'47', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (59, N'MERSİN', N'324', N'33', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (60, N'MUĞLA', N'252', N'48', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (61, N'MUŞ', N'436', N'49', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (62, N'NEVŞEHİR', N'384', N'50', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (63, N'NİĞDE', N'388', N'51', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (64, N'ORDU', N'452', N'52', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (65, N'OSMANİYE', N'328', N'80', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (66, N'RİZE', N'464', N'53', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (67, N'SAKARYA', N'264', N'54', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (68, N'SAMSUN', N'362', N'55', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (69, N'SİİRT', N'484', N'56', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (70, N'SİNOP', N'368', N'57', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (71, N'SİVAS', N'346', N'58', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (72, N'ŞANLIURFA', N'414', N'63', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (73, N'ŞIRNAK', N'486', N'73', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (74, N'TEKİRDAĞ', N'282', N'59', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (75, N'TOKAT', N'356', N'60', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (76, N'TRABZON', N'462', N'61', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (77, N'TUNCELİ', N'428', N'62', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (78, N'UŞAK', N'276', N'64', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (79, N'VAN', N'432', N'65', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (80, N'YALOVA', N'226', N'77', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (81, N'YOZGAT', N'354', N'66', 1)
            INSERT [SETUP_CITY] ([CITY_ID], [CITY_NAME], [PHONE_CODE], [PLATE_CODE], [COUNTRY_ID]) VALUES (82, N'ZONGULDAK', N'372', N'67', 1)
        SET IDENTITY_INSERT [SETUP_CITY] OFF
    END;
</querytag>
