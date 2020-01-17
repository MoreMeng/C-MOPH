--
-- PostgreSQL database dump
--

--
-- Name: ccd_appointment; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_appointment";
CREATE VIEW public.ccd_appointment AS
 SELECT '10733'::text AS hospcode,
    a.hn,
    a.vn,
    a.nextdate AS next_visit_date,
    a.nexttime AS next_visit_time,
    d.cid AS doctor_cid,
    concat_ws(' '::text, a.app_cause, a.note, a.note2) AS app_note
   FROM (public.oapp a
     LEFT JOIN public.doctor d ON (((d.code)::text = (a.doctor)::text)));


ALTER TABLE public.ccd_appointment OWNER TO postgres;

--
-- Name: ccd_dispense_items; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_dispense_items";
CREATE VIEW public.ccd_dispense_items AS
 SELECT '10733'::text AS hospcode,
    op.hn,
    op.vn,
    d.icode AS hosp_drug_code,
    concat_ws(' '::text, d.name, d.strength) AS drug_name,
        CASE
            WHEN (op.sp_use IS NULL) THEN concat_ws(' '::text, du.name1, du.name2, du.name3)
            ELSE concat_ws(' '::text, su.name1, su.name1, su.name3)
        END AS drug_usage,
    op.qty,
    d.units AS unit,
    op.unitprice AS unit_price,
    op.sum_price,
    d.did AS didstd,
    d.sks_drug_code AS tmtcode
   FROM (((public.opitemrece op
     JOIN public.drugitems d ON (((d.icode)::text = (op.icode)::text)))
     LEFT JOIN public.drugusage du ON (((du.drugusage)::text = (op.drugusage)::text)))
     LEFT JOIN public.sp_use su ON (((op.sp_use)::text = (su.sp_use)::text)));


ALTER TABLE public.ccd_dispense_items OWNER TO postgres;

--
-- Name: ccd_lab_result; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_lab_result";
CREATE VIEW public.ccd_lab_result AS
 SELECT '10733'::text AS hospcode,
    lh.hn,
    lh.vn,
    lh.order_date,
    li.lab_items_code AS hosp_lab_code,
        CASE
            WHEN (los.lab_order_type IS NULL) THEN '-'::character varying
            ELSE los.lab_name
        END AS lab_group_name,
    li.provis_labcode,
    li.lab_items_name,
    lo.lab_order_result,
    li.lab_items_unit,
    lo.lab_items_normal_value_ref AS lab_items_normal_value
   FROM (((public.lab_head lh
     LEFT JOIN public.lab_order lo ON ((lh.lab_order_number = lo.lab_order_number)))
     LEFT JOIN public.lab_order_service los ON (((los.lab_order_number = lo.lab_order_number) AND (los.lab_code = lo.lab_items_sub_group_code))))
     LEFT JOIN public.lab_items li ON ((li.lab_items_code = lo.lab_items_code)))
  WHERE (lo.confirm = 'Y'::bpchar);


ALTER TABLE public.ccd_lab_result OWNER TO postgres;

--
-- Name: ccd_opd_visit; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_opd_visit";
CREATE VIEW public.ccd_opd_visit AS
 SELECT '10733'::text AS hospcode,
    o.hn,
    o.vn,
    o.an,
    o.vstdate,
    o.vsttime,
    s.provis_code AS clinic_code,
    pv.pttype_std_code,
    pv.name,
    psc.pttype_std_name
   FROM ((((((public.ovst o
     LEFT JOIN public.visit_pttype vp ON (((vp.vn)::text = (o.vn)::text)))
     LEFT JOIN public.pttype t ON ((t.pttype = vp.pttype)))
     LEFT JOIN public.provis_instype pv ON ((pv.code = t.nhso_code)))
     LEFT JOIN public.kskdepartment k ON ((k.depcode = o.main_dep)))
     LEFT JOIN public.spclty s ON ((s.spclty = k.spclty)))
     LEFT JOIN public.pttype_std_code psc ON ((psc.pttype_std_code = pv.pttype_std_code)));


ALTER TABLE public.ccd_opd_visit OWNER TO postgres;

--
-- Name: ccd_opd_visit_diag; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_opd_visit_diag";
CREATE VIEW public.ccd_opd_visit_diag AS
 SELECT '10733'::text AS hospcode,
    odx.hn,
    odx.vn,
    odx.icd10,
    i.name AS diag_name,
    odx.diagtype AS diag_type,
    d.cid AS doctor_cid
   FROM ((public.ovstdiag odx
     JOIN public.icd101 i ON (((i.code)::text = (odx.icd10)::text)))
     LEFT JOIN public.doctor d ON (((d.code)::text = (odx.doctor)::text)));


ALTER TABLE public.ccd_opd_visit_diag OWNER TO postgres;

--
-- Name: ccd_opd_visit_diag_text; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_opd_visit_diag_text";
CREATE VIEW public.ccd_opd_visit_diag_text AS
 SELECT '10733'::text AS hospcode,
    o.hn,
    oddx.vn,
    d.cid,
    oddx.diag_text
   FROM ((public.ovst_doctor_diag oddx
     JOIN public.ovst o ON (((oddx.vn)::text = (o.vn)::text)))
     LEFT JOIN public.doctor d ON (((d.code)::text = (oddx.doctor_code)::text)));


ALTER TABLE public.ccd_opd_visit_diag_text OWNER TO postgres;

--
-- Name: ccd_opd_visit_procedure; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_opd_visit_procedure";
CREATE VIEW public.ccd_opd_visit_procedure AS
 SELECT '10733'::text AS hospcode,
    odx.hn,
    odx.vn,
    odx.icd10,
    i.name AS diag_name,
    odx.diagtype AS diag_type,
    d.cid AS doctor_cid
   FROM ((public.ovstdiag odx
     JOIN public.icd9cm1 i ON (((i.code)::text = (odx.icd10)::text)))
     LEFT JOIN public.doctor d ON (((d.code)::text = (odx.doctor)::text)));


ALTER TABLE public.ccd_opd_visit_procedure OWNER TO postgres;

--
-- Name: ccd_opd_visit_screen; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_opd_visit_screen";
CREATE VIEW public.ccd_opd_visit_screen AS
 SELECT '10733'::text AS hospcode,
    opdscreen.hn,
    opdscreen.vn,
    opdscreen.cc,
    opdscreen.hpi,
    opdscreen.bpd AS dbp,
    opdscreen.bps AS sbp,
    opdscreen.hr AS heart_rate,
    opdscreen.pulse,
    opdscreen.rr AS respiratory_rate,
    opdscreen.temperature,
    opdscreen.bw AS weight,
    opdscreen.height,
    opdscreen.bmi,
    opdscreen.waist,
    opdscreen.pe,
    opdscreen.drinking_type_id AS alcohol_use,
    opdscreen.smoking_type_id AS cigar_use,
    opdscreen.pregnancy AS pregnant,
    opdscreen.breast_feeding AS lactation,
    opdscreen.pre_pain_score AS pain_score,
    opdscreen.advice7_note AS note
   FROM public.opdscreen;


ALTER TABLE public.ccd_opd_visit_screen OWNER TO postgres;

--
-- Name: ccd_person; Type: VIEW; Schema: public; Owner: postgres
--

DROP VIEW IF EXISTS "public"."ccd_person";
CREATE VIEW public.ccd_person AS
 SELECT '10733'::text AS hospcode,
    pt.cid,
    pt.hn,
    pn.provis_code AS provis_pname,
    pt.fname,
    pt.lname,
    pt.birthday,
    pt.sex,
    mr.nhso_marriage_code,
    n.nhso_code AS nation_code,
    c.nhso_code AS citizenship,
    r.nhso_code AS religion_code,
    pt.addrpart AS address,
    pt.moopart AS moo,
    pt.road AS street,
    pt.tmbpart AS subdistrict_code,
    pt.amppart AS district_code,
    pt.chwpart AS province_code,
    concat(pt.chwpart, pt.amppart, pt.tmbpart) AS address_id,
    pt.hometel AS telephone,
    pt.hometel AS mobile,
    pt.informname,
    pt.informtel,
    pt.drugallergy,
    pt.passport_no
   FROM (((((public.patient pt
     JOIN public.pname pn ON (((pn.name)::text = (pt.pname)::text)))
     JOIN public.marrystatus mr ON ((mr.code = pt.marrystatus)))
     JOIN public.nationality n ON ((n.nationality = pt.nationality)))
     JOIN public.nationality c ON ((c.nationality = pt.citizenship)))
     JOIN public.religion r ON ((r.religion = pt.religion)));


ALTER TABLE public.ccd_person OWNER TO postgres;

--
-- PostgreSQL database dump complete
--