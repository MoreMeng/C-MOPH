#run คำสั่งนี้นะครับ แต่ต้อง....
#เปลี่ยน 10733 เป็นรหัส รพ. 5 หลัก
#เปลี่ยน admin เป็น user ที่ใช้ connect HOSxP

-- Dumping structure for event hos.CCD_CreateView
DROP EVENT IF EXISTS `CCD_CreateView`;
DELIMITER //
CREATE DEFINER=`admin`@`%` EVENT `CCD_CreateView` ON SCHEDULE EVERY 1 DAY STARTS '2019-09-24 08:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN

DROP VIEW IF EXISTS `ccd_appointment`;
DROP VIEW IF EXISTS `ccd_dispense_items`;
DROP VIEW IF EXISTS `ccd_lab_result`;
DROP VIEW IF EXISTS `ccd_opd_visit`;
DROP VIEW IF EXISTS `ccd_opd_visit_diag`;
DROP VIEW IF EXISTS `ccd_opd_visit_diag_text`;
DROP VIEW IF EXISTS `ccd_opd_visit_procedure`;
DROP VIEW IF EXISTS `ccd_opd_visit_screen`;
DROP VIEW IF EXISTS `ccd_person`;

DROP TABLE IF EXISTS `tbl_ccd_appointment`;
DROP TABLE IF EXISTS `tbl_ccd_dispense_items`;
DROP TABLE IF EXISTS `tbl_ccd_lab_result`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit_diag`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit_diag_text`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit_procedure`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit_screen`;
DROP TABLE IF EXISTS `tbl_ccd_person`;

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_appointment AS select '10733' AS `hospcode`,`a`.`hn` AS `hn`,`a`.`vn` AS `vn`,`a`.`nextdate` AS `next_visit_date`,`a`.`nexttime` AS `next_visit_time`,`d`.`cid` AS `doctor_cid`,concat_ws(' ',`a`.`app_cause`,`a`.`note`,`a`.`note2`) AS app_note from oapp a left join doctor d on `d`.`code` = `a`.`doctor`;

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_dispense_items AS select '10733' AS `hospcode`,`op`.`hn` AS `hn`,`op`.`vn` AS `vn`,`d`.`icode` AS `hosp_drug_code`,concat_ws(' ',`d`.`name`,`d`.`strength`) AS `drug_name`,`d`.`dosageform` AS `dosage_form`,`d`.`strength` AS `strength`,if(isnull(`op`.`sp_use`),concat_ws(' ',`du`.`name1`,`du`.`name2`,`du`.`name3`),concat_ws(' ',`su`.`name1`,`su`.`name1`,`su`.`name3`)) AS `drug_usage`,`op`.`qty` AS `qty`,`d`.`units` AS `unit`,`op`.`unitprice` AS `unit_price`,`op`.`sum_price` AS `sum_price`,`d`.`did` AS `didstd`,`d`.`sks_drug_code` AS tmtcode from opitemrece op join drugitems d on `d`.`icode` = `op`.`icode` left join drugusage du on `du`.`drugusage` = `op`.`drugusage` left join sp_use su on `op`.`sp_use` = `su`.`sp_use`;

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_lab_result AS select '10733' AS `hospcode`,`lh`.`hn` AS `hn`,`lh`.`vn` AS `vn`,`lh`.`order_date` AS `order_date`,`li`.`lab_items_code` AS `hosp_lab_code`,if(isnull(los.lab_order_type),"-",`los`.`lab_name`) AS `lab_group_name`,`li`.`provis_labcode` AS `provis_labcode`,`li`.`lab_items_name` AS `lab_items_name`,`lo`.`lab_order_result` AS `lab_order_result`,`li`.`lab_items_unit` AS `lab_items_unit`,`lo`.`lab_items_normal_value_ref` AS lab_items_normal_value from lab_head lh left join lab_order lo on `lh`.`lab_order_number` = `lo`.`lab_order_number` left join lab_order_service los on `los`.`lab_order_number` = `lo`.`lab_order_number` and `los`.`lab_code` = `lab_items_sub_group_code` left join lab_items li on `li`.`lab_items_code` = `lo`.`lab_items_code` where `lo`.`confirm` = 'Y';

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_opd_visit AS select '10733' AS `hospcode`,`o`.`hn` AS `hn`,`o`.`vn` AS `vn`,`o`.`an` AS `an`,`o`.`vstdate` AS `vstdate`,`o`.`vsttime` AS `vsttime`,`s`.`provis_code` AS `clinic_code`,`pv`.`pttype_std_code` AS `pttype_std_code`,`k`.`department` AS `name`,`psc`.`pttype_std_name` AS pttype_std_name from ovst o left join visit_pttype vp on `vp`.`vn` = `o`.`vn` left join pttype t on `t`.`pttype` = `vp`.`pttype` left join provis_instype pv on `pv`.`code` = `t`.`nhso_code` left join kskdepartment k on `k`.`depcode` = `o`.`main_dep` left join spclty s on `s`.`spclty` = `k`.`spclty` left join pttype_std_code psc on `psc`.`pttype_std_code` = `pv`.`pttype_std_code`;

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_opd_visit_diag AS select '10733' AS `hospcode`,`odx`.`hn` AS `hn`,`odx`.`vn` AS `vn`,`odx`.`icd10` AS `icd10`,`i`.`name` AS `diag_name`,`odx`.`diagtype` AS `diag_type`,`d`.`cid` AS doctor_cid from ovstdiag odx join icd101 i on `i`.`code` = `odx`.`icd10` left join doctor d on `d`.`code` = `odx`.`doctor`;

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_opd_visit_diag_text AS select '10733' AS `hospcode`,`o`.`hn` AS `hn`,`oddx`.`vn` AS `vn`,`d`.`cid` AS `doctor_cid`,`oddx`.`diag_text` AS diag_text from ovst_doctor_diag oddx join ovst o on `oddx`.`vn` = `o`.`vn` left join doctor d on `d`.`code` = `oddx`.`doctor_code`;

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_opd_visit_procedure AS select '10733' AS `hospcode`,`odx`.`hn` AS `hn`,`odx`.`vn` AS `vn`,`odx`.`icd10` AS `icd10`,`i`.`name` AS `diag_name`,`odx`.`diagtype` AS `diag_type`,`d`.`cid` AS doctor_cid from ovstdiag odx join icd9cm1 i on `i`.`code` = `odx`.`icd10` left join doctor d on `d`.`code` = `odx`.`doctor`;

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_opd_visit_screen AS select '10733' AS `hospcode`,`opdscreen`.`hn` AS `hn`,`opdscreen`.`vn` AS `vn`,`opdscreen`.`cc` AS `cc`,`opdscreen`.`hpi` AS `hpi`,`opdscreen`.`bpd` AS `dbp`,`opdscreen`.`bps` AS `sbp`,`opdscreen`.`hr` AS `heart_rate`,`opdscreen`.`pulse` AS `pulse`,`opdscreen`.`rr` AS `respiratory_rate`,`opdscreen`.`temperature` AS `temperature`,`opdscreen`.`bw` AS `weight`,`opdscreen`.`height` AS `height`,`opdscreen`.`bmi` AS `bmi`,`opdscreen`.`waist` AS `waist`,`opdscreen`.`pe` AS `pe`,`opdscreen`.`drinking_type_id` AS `alcohol_use`,`opdscreen`.`smoking_type_id` AS `cigar_use`,`opdscreen`.`pregnancy` AS `pregnant`,`opdscreen`.`breast_feeding` AS `lactation`,`opdscreen`.`pre_pain_score` AS `pain_score`,`opdscreen`.`advice7_note` AS note from `opdscreen`;

CREATE ALGORITHM=MERGE DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW ccd_person AS select '10733' AS `hospcode`,`pt`.`cid` AS `cid`,`pt`.`hn` AS `hn`,`pn`.`provis_code` AS `provis_pname`,`pt`.`fname` AS `fname`,`pt`.`lname` AS `lname`,`pt`.`birthday` AS `birthday`,`pt`.`sex` AS `sex`,`mr`.`nhso_marriage_code` AS `nhso_marriage_code`,`n`.`nhso_code` AS `nation_code`,`c`.`nhso_code` AS `citizenship`,`r`.`nhso_code` AS `religion_code`,`pt`.`addrpart` AS `address`,`pt`.`moopart` AS `moo`,`pt`.`road` AS `street`,`pt`.`tmbpart` AS `subdistrict_code`,`pt`.`amppart` AS `district_code`,`pt`.`chwpart` AS `province_code`,concat(`pt`.`chwpart`,`pt`.`amppart`,`pt`.`tmbpart`) AS `address_id`,`pt`.`hometel` AS `telephone`,`pt`.`hometel` AS `mobile`,`pt`.`informname` AS `informname`,`pt`.`informtel` AS `informtel`,`pt`.`drugallergy` AS drugallergy, `pt`.`passport_no` AS `passport_no` from patient pt join pname pn on `pn`.`name` = `pt`.`pname` join marrystatus mr on `mr`.`code` = `pt`.`marrystatus` join nationality n on `n`.`nationality` = `pt`.`nationality` join nationality c on `c`.`nationality` = `pt`.`citizenship` join religion r on `r`.`religion` = `pt`.`religion`;

END//
DELIMITER ;

-- Dumping structure for event hos.CCD_DropView
DROP EVENT IF EXISTS `CCD_DropView`;
DELIMITER //
CREATE DEFINER=`admin`@`%` EVENT `CCD_DropView` ON SCHEDULE EVERY 1 DAY STARTS '2019-09-24 00:15:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN

DROP VIEW IF EXISTS `ccd_appointment`;
DROP VIEW IF EXISTS `ccd_dispense_items`;
DROP VIEW IF EXISTS `ccd_lab_result`;
DROP VIEW IF EXISTS `ccd_opd_visit`;
DROP VIEW IF EXISTS `ccd_opd_visit_diag`;
DROP VIEW IF EXISTS `ccd_opd_visit_diag_text`;
DROP VIEW IF EXISTS `ccd_opd_visit_procedure`;
DROP VIEW IF EXISTS `ccd_opd_visit_screen`;
DROP VIEW IF EXISTS `ccd_person`;

DROP TABLE IF EXISTS `tbl_ccd_appointment`;
DROP TABLE IF EXISTS `tbl_ccd_dispense_items`;
DROP TABLE IF EXISTS `tbl_ccd_lab_result`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit_diag`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit_diag_text`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit_procedure`;
DROP TABLE IF EXISTS `tbl_ccd_opd_visit_screen`;
DROP TABLE IF EXISTS `tbl_ccd_person`;

END//
DELIMITER ;