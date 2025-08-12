--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO postgres;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_attachments_id_seq OWNER TO postgres;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO postgres;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_blobs_id_seq OWNER TO postgres;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO postgres;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_variant_records_id_seq OWNER TO postgres;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: anthropologies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.anthropologies (
    id bigint NOT NULL,
    sex_morph integer,
    sex_gen integer,
    sex_consensus integer,
    age_as_reported character varying,
    age_class integer,
    height double precision,
    pathologies_type character varying,
    skeleton_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    species integer
);


ALTER TABLE public.anthropologies OWNER TO postgres;

--
-- Name: anthropologies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.anthropologies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.anthropologies_id_seq OWNER TO postgres;

--
-- Name: anthropologies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.anthropologies_id_seq OWNED BY public.anthropologies.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: bones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bones (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.bones OWNER TO postgres;

--
-- Name: bones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bones_id_seq OWNER TO postgres;

--
-- Name: bones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bones_id_seq OWNED BY public.bones.id;


--
-- Name: c14_dates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.c14_dates (
    id bigint NOT NULL,
    c14_type integer NOT NULL,
    lab_id character varying,
    age_bp integer,
    "interval" integer,
    material integer,
    calbc_1_sigma_max double precision,
    calbc_1_sigma_min double precision,
    calbc_2_sigma_max double precision,
    calbc_2_sigma_min double precision,
    date_note character varying,
    cal_method integer,
    ref_14c character varying,
    chronology_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    bone_id bigint
);


ALTER TABLE public.c14_dates OWNER TO postgres;

--
-- Name: c14_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.c14_dates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.c14_dates_id_seq OWNER TO postgres;

--
-- Name: c14_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.c14_dates_id_seq OWNED BY public.c14_dates.id;


--
-- Name: chronologies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chronologies (
    id bigint NOT NULL,
    context_from integer,
    context_to integer,
    skeleton_id bigint,
    grave_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    period_id bigint
);


ALTER TABLE public.chronologies OWNER TO postgres;

--
-- Name: chronologies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chronologies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chronologies_id_seq OWNER TO postgres;

--
-- Name: chronologies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chronologies_id_seq OWNED BY public.chronologies.id;


--
-- Name: cultures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cultures (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.cultures OWNER TO postgres;

--
-- Name: cultures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cultures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cultures_id_seq OWNER TO postgres;

--
-- Name: cultures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cultures_id_seq OWNED BY public.cultures.id;


--
-- Name: figures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.figures (
    id bigint NOT NULL,
    upload_item_id bigint NOT NULL,
    x1 integer,
    x2 integer,
    y1 integer,
    y2 integer,
    type character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    area double precision,
    perimeter double precision,
    milli_meter_ratio double precision,
    parent_id integer,
    identifier character varying,
    width double precision,
    height double precision,
    text character varying,
    upload_id integer,
    manual_bounding_box boolean DEFAULT false,
    probability double precision,
    real_world_area double precision,
    real_world_width double precision,
    real_world_height double precision,
    real_world_perimeter double precision,
    strain_id integer,
    control_points integer[],
    anchor_points integer[],
    view integer,
    contour jsonb
);


ALTER TABLE public.figures OWNER TO postgres;

--
-- Name: figures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.figures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.figures_id_seq OWNER TO postgres;

--
-- Name: figures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.figures_id_seq OWNED BY public.figures.id;


--
-- Name: figures_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.figures_tags (
    id bigint NOT NULL,
    tag_id bigint,
    figure_id bigint
);


ALTER TABLE public.figures_tags OWNER TO postgres;

--
-- Name: figures_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.figures_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.figures_tags_id_seq OWNER TO postgres;

--
-- Name: figures_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.figures_tags_id_seq OWNED BY public.figures_tags.id;


--
-- Name: genetics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genetics (
    id bigint NOT NULL,
    data_type integer,
    endo_content double precision,
    ref_gen character varying,
    skeleton_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    mt_haplogroup_id bigint,
    y_haplogroup_id bigint,
    bone_id bigint
);


ALTER TABLE public.genetics OWNER TO postgres;

--
-- Name: genetics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genetics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.genetics_id_seq OWNER TO postgres;

--
-- Name: genetics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genetics_id_seq OWNED BY public.genetics.id;


--
-- Name: grains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grains (
    id bigint NOT NULL,
    site_id bigint NOT NULL,
    strain_id bigint NOT NULL,
    dorsal_id bigint,
    ventral_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    identifier character varying,
    lateral_id bigint,
    ts_id bigint,
    complete boolean,
    validated boolean,
    upload_id bigint
);


ALTER TABLE public.grains OWNER TO postgres;

--
-- Name: grains_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grains_id_seq OWNER TO postgres;

--
-- Name: grains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grains_id_seq OWNED BY public.grains.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.images (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    width integer,
    height integer
);


ALTER TABLE public.images OWNER TO postgres;

--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.images_id_seq OWNER TO postgres;

--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: kurgans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kurgans (
    id bigint NOT NULL,
    width integer,
    height integer,
    name character varying NOT NULL,
    publication_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.kurgans OWNER TO postgres;

--
-- Name: kurgans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kurgans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kurgans_id_seq OWNER TO postgres;

--
-- Name: kurgans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kurgans_id_seq OWNED BY public.kurgans.id;


--
-- Name: mt_haplogroups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mt_haplogroups (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.mt_haplogroups OWNER TO postgres;

--
-- Name: mt_haplogroups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mt_haplogroups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mt_haplogroups_id_seq OWNER TO postgres;

--
-- Name: mt_haplogroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mt_haplogroups_id_seq OWNED BY public.mt_haplogroups.id;


--
-- Name: page_texts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page_texts (
    id bigint NOT NULL,
    page_id bigint NOT NULL,
    text character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.page_texts OWNER TO postgres;

--
-- Name: page_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.page_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_texts_id_seq OWNER TO postgres;

--
-- Name: page_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.page_texts_id_seq OWNED BY public.page_texts.id;


--
-- Name: periods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periods (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.periods OWNER TO postgres;

--
-- Name: periods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.periods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.periods_id_seq OWNER TO postgres;

--
-- Name: periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.periods_id_seq OWNED BY public.periods.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: sites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sites (
    id bigint NOT NULL,
    lat double precision,
    lon double precision,
    name character varying,
    locality character varying,
    country_code integer,
    site_code character varying
);


ALTER TABLE public.sites OWNER TO postgres;

--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sites_id_seq OWNER TO postgres;

--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sites_id_seq OWNED BY public.sites.id;


--
-- Name: skeletons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skeletons (
    id bigint NOT NULL,
    figure_id integer NOT NULL,
    angle double precision,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    skeleton_id character varying,
    funerary_practice integer,
    inhumation_type integer,
    anatonimcal_connection integer,
    body_position integer,
    crouching_type integer,
    other character varying,
    head_facing double precision,
    ochre integer,
    ochre_position integer,
    skeleton_figure_id bigint,
    site_id bigint
);


ALTER TABLE public.skeletons OWNER TO postgres;

--
-- Name: skeletons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skeletons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.skeletons_id_seq OWNER TO postgres;

--
-- Name: skeletons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skeletons_id_seq OWNED BY public.skeletons.id;


--
-- Name: stable_isotopes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stable_isotopes (
    id bigint NOT NULL,
    skeleton_id bigint NOT NULL,
    iso_id character varying,
    iso_value double precision,
    ref_iso character varying,
    isotope integer,
    baseline integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    bone_id bigint
);


ALTER TABLE public.stable_isotopes OWNER TO postgres;

--
-- Name: stable_isotopes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stable_isotopes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stable_isotopes_id_seq OWNER TO postgres;

--
-- Name: stable_isotopes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stable_isotopes_id_seq OWNED BY public.stable_isotopes.id;


--
-- Name: strains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.strains (
    id bigint NOT NULL,
    name character varying
);


ALTER TABLE public.strains OWNER TO postgres;

--
-- Name: strains_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.strains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.strains_id_seq OWNER TO postgres;

--
-- Name: strains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.strains_id_seq OWNED BY public.strains.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: taxonomies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxonomies (
    id bigint NOT NULL,
    skeleton_id bigint,
    culture_note character varying,
    culture_reference character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    culture_id bigint
);


ALTER TABLE public.taxonomies OWNER TO postgres;

--
-- Name: taxonomies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.taxonomies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taxonomies_id_seq OWNER TO postgres;

--
-- Name: taxonomies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.taxonomies_id_seq OWNED BY public.taxonomies.id;


--
-- Name: text_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.text_items (
    id bigint NOT NULL,
    page_id bigint NOT NULL,
    text character varying,
    x1 integer,
    x2 integer,
    y1 integer,
    y2 integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.text_items OWNER TO postgres;

--
-- Name: text_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.text_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.text_items_id_seq OWNER TO postgres;

--
-- Name: text_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.text_items_id_seq OWNED BY public.text_items.id;


--
-- Name: upload_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.upload_items (
    id bigint NOT NULL,
    upload_id bigint NOT NULL,
    image_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.upload_items OWNER TO postgres;

--
-- Name: upload_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.upload_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.upload_items_id_seq OWNER TO postgres;

--
-- Name: upload_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.upload_items_id_seq OWNED BY public.upload_items.id;


--
-- Name: uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uploads (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id bigint,
    public boolean DEFAULT false NOT NULL,
    name character varying,
    site_id integer,
    strain_id integer,
    view integer,
    feature character varying,
    sample character varying
);


ALTER TABLE public.uploads OWNER TO postgres;

--
-- Name: uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uploads_id_seq OWNER TO postgres;

--
-- Name: uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uploads_id_seq OWNED BY public.uploads.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying,
    code_hash character varying,
    name character varying,
    role integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: y_haplogroups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.y_haplogroups (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.y_haplogroups OWNER TO postgres;

--
-- Name: y_haplogroups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.y_haplogroups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.y_haplogroups_id_seq OWNER TO postgres;

--
-- Name: y_haplogroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.y_haplogroups_id_seq OWNED BY public.y_haplogroups.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: anthropologies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anthropologies ALTER COLUMN id SET DEFAULT nextval('public.anthropologies_id_seq'::regclass);


--
-- Name: bones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bones ALTER COLUMN id SET DEFAULT nextval('public.bones_id_seq'::regclass);


--
-- Name: c14_dates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.c14_dates ALTER COLUMN id SET DEFAULT nextval('public.c14_dates_id_seq'::regclass);


--
-- Name: chronologies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chronologies ALTER COLUMN id SET DEFAULT nextval('public.chronologies_id_seq'::regclass);


--
-- Name: cultures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultures ALTER COLUMN id SET DEFAULT nextval('public.cultures_id_seq'::regclass);


--
-- Name: figures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.figures ALTER COLUMN id SET DEFAULT nextval('public.figures_id_seq'::regclass);


--
-- Name: figures_tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.figures_tags ALTER COLUMN id SET DEFAULT nextval('public.figures_tags_id_seq'::regclass);


--
-- Name: genetics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetics ALTER COLUMN id SET DEFAULT nextval('public.genetics_id_seq'::regclass);


--
-- Name: grains id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grains ALTER COLUMN id SET DEFAULT nextval('public.grains_id_seq'::regclass);


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: kurgans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kurgans ALTER COLUMN id SET DEFAULT nextval('public.kurgans_id_seq'::regclass);


--
-- Name: mt_haplogroups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mt_haplogroups ALTER COLUMN id SET DEFAULT nextval('public.mt_haplogroups_id_seq'::regclass);


--
-- Name: page_texts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_texts ALTER COLUMN id SET DEFAULT nextval('public.page_texts_id_seq'::regclass);


--
-- Name: periods id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periods ALTER COLUMN id SET DEFAULT nextval('public.periods_id_seq'::regclass);


--
-- Name: sites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sites ALTER COLUMN id SET DEFAULT nextval('public.sites_id_seq'::regclass);


--
-- Name: skeletons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skeletons ALTER COLUMN id SET DEFAULT nextval('public.skeletons_id_seq'::regclass);


--
-- Name: stable_isotopes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stable_isotopes ALTER COLUMN id SET DEFAULT nextval('public.stable_isotopes_id_seq'::regclass);


--
-- Name: strains id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.strains ALTER COLUMN id SET DEFAULT nextval('public.strains_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: taxonomies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomies ALTER COLUMN id SET DEFAULT nextval('public.taxonomies_id_seq'::regclass);


--
-- Name: text_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.text_items ALTER COLUMN id SET DEFAULT nextval('public.text_items_id_seq'::regclass);


--
-- Name: upload_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload_items ALTER COLUMN id SET DEFAULT nextval('public.upload_items_id_seq'::regclass);


--
-- Name: uploads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploads ALTER COLUMN id SET DEFAULT nextval('public.uploads_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: y_haplogroups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.y_haplogroups ALTER COLUMN id SET DEFAULT nextval('public.y_haplogroups_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
1	zip	Upload	1	1	2025-04-29 08:25:59.972429
2	zip	Upload	2	2	2025-04-29 08:26:24.908572
3	zip	Upload	3	3	2025-04-29 08:32:42.656424
4	zip	Upload	4	4	2025-04-29 08:39:44.092703
5	zip	Upload	5	5	2025-04-29 08:44:36.084686
6	zip	Upload	6	6	2025-04-29 08:46:26.140661
7	zip	Upload	7	7	2025-04-29 11:20:11.914082
8	zip	Upload	8	8	2025-04-29 11:28:44.592783
9	zip	Upload	9	9	2025-04-29 11:31:20.255598
10	zip	Upload	10	10	2025-06-26 22:28:51.049224
11	zip	Upload	11	11	2025-06-27 07:56:05.528299
12	zip	Upload	12	12	2025-06-27 11:23:48.598883
13	zip	Upload	13	13	2025-06-27 11:24:37.512439
14	zip	Upload	14	14	2025-08-11 06:50:44.051664
15	zip	Upload	15	15	2025-08-12 08:06:11.863138
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
1	8epize1wu6klx7wz8bxa8kwxps2u	test.zip	application/zip	{"identified":true,"analyzed":true}	local	3941891	KhHtPcSRs+RuJfulMNJASw==	2025-04-29 08:25:59.968713
2	qup24475e1m39tbw5xsf38cqh67i	test.zip	application/zip	{"identified":true,"analyzed":true}	local	3941891	KhHtPcSRs+RuJfulMNJASw==	2025-04-29 08:26:24.905221
3	xusrjtm5o4yzqlxynin87kkg2ob7	test.zip	application/zip	{"identified":true,"analyzed":true}	local	3941891	KhHtPcSRs+RuJfulMNJASw==	2025-04-29 08:32:42.608043
4	9v9nj94qofz9xisxrwt33vnmusot	test.zip	application/zip	{"identified":true,"analyzed":true}	local	3941891	KhHtPcSRs+RuJfulMNJASw==	2025-04-29 08:39:44.072544
5	xu420xte63bnqq188e5ub4jms3ft	test.zip	application/zip	{"identified":true,"analyzed":true}	local	3941891	KhHtPcSRs+RuJfulMNJASw==	2025-04-29 08:44:36.081936
6	g1zwap8qev9dvnu9ev4yu6p3tny5	test.zip	application/zip	{"identified":true,"analyzed":true}	local	3941891	KhHtPcSRs+RuJfulMNJASw==	2025-04-29 08:46:26.138248
7	nlmcxhe4epu436ta6ypalwyzmhqt	test.zip	application/zip	{"identified":true,"analyzed":true}	local	3941891	KhHtPcSRs+RuJfulMNJASw==	2025-04-29 11:20:11.912082
8	nv1k2sfaa017nmfdqwkpq3v9ui8y	kov bar.zip	application/zip	{"identified":true,"analyzed":true}	local	11850465	exY/H/l6XAJ7+xb2xu5vxg==	2025-04-29 11:28:44.589977
9	4pk8dr5tsi8u8808o97f32m2cdbk	kov bar.zip	application/zip	{"identified":true,"analyzed":true}	local	11850457	UqeO7Wc9+ph1dBW4IfB4rg==	2025-04-29 11:31:20.253804
10	lvi5sb5rpihh39w5utuwp7aseuwv	test.zip	application/zip	{"identified":true,"analyzed":true}	local	3941891	KhHtPcSRs+RuJfulMNJASw==	2025-06-26 22:28:51.045921
11	tn7dmjpuplzjr4kdyw1kapy99iz3	kov bar.zip	application/zip	{"identified":true,"analyzed":true}	local	11850457	UqeO7Wc9+ph1dBW4IfB4rg==	2025-06-27 07:56:05.522011
12	6q5shwkqiwlj680wpcoru4vdewhf	test fixed.zip	application/zip	{"identified":true,"analyzed":true}	local	11850457	EVojVgCxnKqDoUDHUVerkA==	2025-06-27 11:23:48.594204
13	y4k7kb0s3v9ml2spqnjxice6wpyh	test fixed.zip	application/zip	{"identified":true,"analyzed":true}	local	11850457	EVojVgCxnKqDoUDHUVerkA==	2025-06-27 11:24:37.50769
14	4xbrd9mohrd3kls2mkzr24t9pxta	kov bar.zip	application/zip	{"identified":true,"analyzed":true}	local	11850457	UqeO7Wc9+ph1dBW4IfB4rg==	2025-08-11 06:50:44.048034
15	wetibso4jvzmv59ph616km3pe3ac	kov bar.zip	application/zip	{"identified":true,"analyzed":true}	local	11850457	UqeO7Wc9+ph1dBW4IfB4rg==	2025-08-12 08:06:11.859333
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: anthropologies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.anthropologies (id, sex_morph, sex_gen, sex_consensus, age_as_reported, age_class, height, pathologies_type, skeleton_id, created_at, updated_at, species) FROM stdin;
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-04-29 07:23:34.192129	2025-04-29 07:23:34.192129
\.


--
-- Data for Name: bones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bones (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: c14_dates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.c14_dates (id, c14_type, lab_id, age_bp, "interval", material, calbc_1_sigma_max, calbc_1_sigma_min, calbc_2_sigma_max, calbc_2_sigma_min, date_note, cal_method, ref_14c, chronology_id, created_at, updated_at, bone_id) FROM stdin;
\.


--
-- Data for Name: chronologies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chronologies (id, context_from, context_to, skeleton_id, grave_id, created_at, updated_at, period_id) FROM stdin;
\.


--
-- Data for Name: cultures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cultures (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: figures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.figures (id, upload_item_id, x1, x2, y1, y2, type, created_at, updated_at, area, perimeter, milli_meter_ratio, parent_id, identifier, width, height, text, upload_id, manual_bounding_box, probability, real_world_area, real_world_width, real_world_height, real_world_perimeter, strain_id, control_points, anchor_points, view, contour) FROM stdin;
\.


--
-- Data for Name: figures_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.figures_tags (id, tag_id, figure_id) FROM stdin;
\.


--
-- Data for Name: genetics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genetics (id, data_type, endo_content, ref_gen, skeleton_id, created_at, updated_at, mt_haplogroup_id, y_haplogroup_id, bone_id) FROM stdin;
\.


--
-- Data for Name: grains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grains (id, site_id, strain_id, dorsal_id, ventral_id, created_at, updated_at, identifier, lateral_id, ts_id, complete, validated, upload_id) FROM stdin;
\.


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.images (id, created_at, updated_at, width, height) FROM stdin;
\.


--
-- Data for Name: kurgans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kurgans (id, width, height, name, publication_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mt_haplogroups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mt_haplogroups (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: page_texts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page_texts (id, page_id, text, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: periods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periods (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20220927120113
20220928144108
20220928144127
20220930171030
20221112162039
20221112162123
20221112162218
20221112162245
20221112162327
20221112162410
20221125145552
20221126185330
20221129184744
20221204154616
20221204154639
20221209161731
20221211184616
20221211201706
20221218162319
20230115172254
20230117154706
20230117165814
20230117170212
20230117171357
20230117172018
20230117172453
20230117172904
20230117173142
20230117173216
20230117173222
20230117173409
20230117180153
20230117185956
20230118201845
20230118220855
20230120114720
20230120124800
20230120205619
20230122111902
20230122173728
20230123195757
20230127131045
20230127164818
20230127165949
20230128125537
20230128133904
20230128133920
20230128161241
20230203103622
20230204122231
20230205134429
20230215235752
20230305112439
20230305151353
20230306111335
20230306115210
20230604104715
20230604120316
20230815172209
20230817094930
20230827170115
20230903173624
20230907112913
20240117000007
20240309211609
20240310154201
20240318121818
20240522101728
20240525115930
20240530123803
20240813142400
20241002152640
20250417062907
20250417065858
20250417072041
20250417085519
20250417175354
20250417185207
20250424084955
20250424085004
20250428065249
20250430104913
20250505112330
20250507110418
20250627114752
20250627114935
20250731074449
\.


--
-- Data for Name: sites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sites (id, lat, lon, name, locality, country_code, site_code) FROM stdin;
\.


--
-- Data for Name: skeletons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skeletons (id, figure_id, angle, created_at, updated_at, skeleton_id, funerary_practice, inhumation_type, anatonimcal_connection, body_position, crouching_type, other, head_facing, ochre, ochre_position, skeleton_figure_id, site_id) FROM stdin;
\.


--
-- Data for Name: stable_isotopes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stable_isotopes (id, skeleton_id, iso_id, iso_value, ref_iso, isotope, baseline, created_at, updated_at, bone_id) FROM stdin;
\.


--
-- Data for Name: strains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.strains (id, name) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (id, name) FROM stdin;
\.


--
-- Data for Name: taxonomies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxonomies (id, skeleton_id, culture_note, culture_reference, created_at, updated_at, culture_id) FROM stdin;
\.


--
-- Data for Name: text_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.text_items (id, page_id, text, x1, x2, y1, y2, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: upload_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.upload_items (id, upload_id, image_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uploads (id, created_at, updated_at, user_id, public, name, site_id, strain_id, view, feature, sample) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, code_hash, name, role, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: y_haplogroups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.y_haplogroups (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 15, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 15, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- Name: anthropologies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.anthropologies_id_seq', 1, false);


--
-- Name: bones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bones_id_seq', 1, false);


--
-- Name: c14_dates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.c14_dates_id_seq', 1, false);


--
-- Name: chronologies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chronologies_id_seq', 1, false);


--
-- Name: cultures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cultures_id_seq', 1, false);


--
-- Name: figures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.figures_id_seq', 131, true);


--
-- Name: figures_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.figures_tags_id_seq', 1, false);


--
-- Name: genetics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genetics_id_seq', 1, false);


--
-- Name: grains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grains_id_seq', 44, true);


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.images_id_seq', 69, true);


--
-- Name: kurgans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kurgans_id_seq', 1, false);


--
-- Name: mt_haplogroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mt_haplogroups_id_seq', 1, false);


--
-- Name: page_texts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.page_texts_id_seq', 1, false);


--
-- Name: periods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.periods_id_seq', 1, false);


--
-- Name: sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sites_id_seq', 2, true);


--
-- Name: skeletons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skeletons_id_seq', 1, false);


--
-- Name: stable_isotopes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stable_isotopes_id_seq', 1, false);


--
-- Name: strains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.strains_id_seq', 2, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_id_seq', 1, false);


--
-- Name: taxonomies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.taxonomies_id_seq', 1, false);


--
-- Name: text_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.text_items_id_seq', 1, false);


--
-- Name: upload_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.upload_items_id_seq', 68, true);


--
-- Name: uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uploads_id_seq', 15, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: y_haplogroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.y_haplogroups_id_seq', 1, false);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: anthropologies anthropologies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anthropologies
    ADD CONSTRAINT anthropologies_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bones bones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bones
    ADD CONSTRAINT bones_pkey PRIMARY KEY (id);


--
-- Name: c14_dates c14_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.c14_dates
    ADD CONSTRAINT c14_dates_pkey PRIMARY KEY (id);


--
-- Name: chronologies chronologies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chronologies
    ADD CONSTRAINT chronologies_pkey PRIMARY KEY (id);


--
-- Name: cultures cultures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cultures
    ADD CONSTRAINT cultures_pkey PRIMARY KEY (id);


--
-- Name: figures figures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.figures
    ADD CONSTRAINT figures_pkey PRIMARY KEY (id);


--
-- Name: figures_tags figures_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.figures_tags
    ADD CONSTRAINT figures_tags_pkey PRIMARY KEY (id);


--
-- Name: genetics genetics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetics
    ADD CONSTRAINT genetics_pkey PRIMARY KEY (id);


--
-- Name: grains grains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grains
    ADD CONSTRAINT grains_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: kurgans kurgans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kurgans
    ADD CONSTRAINT kurgans_pkey PRIMARY KEY (id);


--
-- Name: mt_haplogroups mt_haplogroups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mt_haplogroups
    ADD CONSTRAINT mt_haplogroups_pkey PRIMARY KEY (id);


--
-- Name: page_texts page_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_texts
    ADD CONSTRAINT page_texts_pkey PRIMARY KEY (id);


--
-- Name: periods periods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: skeletons skeletons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skeletons
    ADD CONSTRAINT skeletons_pkey PRIMARY KEY (id);


--
-- Name: stable_isotopes stable_isotopes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stable_isotopes
    ADD CONSTRAINT stable_isotopes_pkey PRIMARY KEY (id);


--
-- Name: strains strains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.strains
    ADD CONSTRAINT strains_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: taxonomies taxonomies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomies
    ADD CONSTRAINT taxonomies_pkey PRIMARY KEY (id);


--
-- Name: text_items text_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.text_items
    ADD CONSTRAINT text_items_pkey PRIMARY KEY (id);


--
-- Name: upload_items upload_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload_items
    ADD CONSTRAINT upload_items_pkey PRIMARY KEY (id);


--
-- Name: uploads uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT uploads_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: y_haplogroups y_haplogroups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.y_haplogroups
    ADD CONSTRAINT y_haplogroups_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_anthropologies_on_skeleton_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_anthropologies_on_skeleton_id ON public.anthropologies USING btree (skeleton_id);


--
-- Name: index_c14_dates_on_bone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_c14_dates_on_bone_id ON public.c14_dates USING btree (bone_id);


--
-- Name: index_c14_dates_on_chronology_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_c14_dates_on_chronology_id ON public.c14_dates USING btree (chronology_id);


--
-- Name: index_chronologies_on_grave_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_chronologies_on_grave_id ON public.chronologies USING btree (grave_id);


--
-- Name: index_chronologies_on_period_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_chronologies_on_period_id ON public.chronologies USING btree (period_id);


--
-- Name: index_chronologies_on_skeleton_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_chronologies_on_skeleton_id ON public.chronologies USING btree (skeleton_id);


--
-- Name: index_figures_on_upload_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_figures_on_upload_item_id ON public.figures USING btree (upload_item_id);


--
-- Name: index_figures_tags_on_figure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_figures_tags_on_figure_id ON public.figures_tags USING btree (figure_id);


--
-- Name: index_figures_tags_on_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_figures_tags_on_tag_id ON public.figures_tags USING btree (tag_id);


--
-- Name: index_genetics_on_bone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_genetics_on_bone_id ON public.genetics USING btree (bone_id);


--
-- Name: index_genetics_on_mt_haplogroup_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_genetics_on_mt_haplogroup_id ON public.genetics USING btree (mt_haplogroup_id);


--
-- Name: index_genetics_on_skeleton_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_genetics_on_skeleton_id ON public.genetics USING btree (skeleton_id);


--
-- Name: index_genetics_on_y_haplogroup_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_genetics_on_y_haplogroup_id ON public.genetics USING btree (y_haplogroup_id);


--
-- Name: index_grains_on_dorsal_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_grains_on_dorsal_id ON public.grains USING btree (dorsal_id);


--
-- Name: index_grains_on_lateral_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_grains_on_lateral_id ON public.grains USING btree (lateral_id);


--
-- Name: index_grains_on_site_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_grains_on_site_id ON public.grains USING btree (site_id);


--
-- Name: index_grains_on_strain_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_grains_on_strain_id ON public.grains USING btree (strain_id);


--
-- Name: index_grains_on_ts_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_grains_on_ts_id ON public.grains USING btree (ts_id);


--
-- Name: index_grains_on_upload_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_grains_on_upload_id ON public.grains USING btree (upload_id);


--
-- Name: index_grains_on_ventral_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_grains_on_ventral_id ON public.grains USING btree (ventral_id);


--
-- Name: index_kurgans_on_publication_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_kurgans_on_publication_id ON public.kurgans USING btree (publication_id);


--
-- Name: index_page_texts_on_page_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_page_texts_on_page_id ON public.page_texts USING btree (page_id);


--
-- Name: index_skeletons_on_figure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_skeletons_on_figure_id ON public.skeletons USING btree (figure_id);


--
-- Name: index_skeletons_on_site_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_skeletons_on_site_id ON public.skeletons USING btree (site_id);


--
-- Name: index_skeletons_on_skeleton_figure_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_skeletons_on_skeleton_figure_id ON public.skeletons USING btree (skeleton_figure_id);


--
-- Name: index_stable_isotopes_on_bone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_stable_isotopes_on_bone_id ON public.stable_isotopes USING btree (bone_id);


--
-- Name: index_stable_isotopes_on_skeleton_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_stable_isotopes_on_skeleton_id ON public.stable_isotopes USING btree (skeleton_id);


--
-- Name: index_taxonomies_on_culture_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_taxonomies_on_culture_id ON public.taxonomies USING btree (culture_id);


--
-- Name: index_taxonomies_on_skeleton_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_taxonomies_on_skeleton_id ON public.taxonomies USING btree (skeleton_id);


--
-- Name: index_text_items_on_page_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_text_items_on_page_id ON public.text_items USING btree (page_id);


--
-- Name: index_upload_items_on_image_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_upload_items_on_image_id ON public.upload_items USING btree (image_id);


--
-- Name: index_upload_items_on_upload_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_upload_items_on_upload_id ON public.upload_items USING btree (upload_id);


--
-- Name: index_uploads_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_uploads_on_user_id ON public.uploads USING btree (user_id);


--
-- Name: grains fk_rails_10b64456af; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grains
    ADD CONSTRAINT fk_rails_10b64456af FOREIGN KEY (lateral_id) REFERENCES public.figures(id);


--
-- Name: grains fk_rails_27ed61df4e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grains
    ADD CONSTRAINT fk_rails_27ed61df4e FOREIGN KEY (strain_id) REFERENCES public.strains(id);


--
-- Name: page_texts fk_rails_30e2bd5652; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_texts
    ADD CONSTRAINT fk_rails_30e2bd5652 FOREIGN KEY (page_id) REFERENCES public.upload_items(id);


--
-- Name: grains fk_rails_311b9cd9e8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grains
    ADD CONSTRAINT fk_rails_311b9cd9e8 FOREIGN KEY (dorsal_id) REFERENCES public.figures(id);


--
-- Name: skeletons fk_rails_3530f65d41; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skeletons
    ADD CONSTRAINT fk_rails_3530f65d41 FOREIGN KEY (figure_id) REFERENCES public.figures(id);


--
-- Name: stable_isotopes fk_rails_44a721f0e7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stable_isotopes
    ADD CONSTRAINT fk_rails_44a721f0e7 FOREIGN KEY (skeleton_id) REFERENCES public.skeletons(id);


--
-- Name: grains fk_rails_4b9bc8d005; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grains
    ADD CONSTRAINT fk_rails_4b9bc8d005 FOREIGN KEY (site_id) REFERENCES public.sites(id);


--
-- Name: grains fk_rails_6a837edec9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grains
    ADD CONSTRAINT fk_rails_6a837edec9 FOREIGN KEY (ts_id) REFERENCES public.figures(id);


--
-- Name: upload_items fk_rails_6e85f0c61d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload_items
    ADD CONSTRAINT fk_rails_6e85f0c61d FOREIGN KEY (upload_id) REFERENCES public.uploads(id) ON DELETE CASCADE;


--
-- Name: upload_items fk_rails_7484eb7907; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload_items
    ADD CONSTRAINT fk_rails_7484eb7907 FOREIGN KEY (image_id) REFERENCES public.images(id) ON DELETE CASCADE;


--
-- Name: figures fk_rails_86f3fd6261; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.figures
    ADD CONSTRAINT fk_rails_86f3fd6261 FOREIGN KEY (upload_item_id) REFERENCES public.upload_items(id) ON DELETE CASCADE;


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: grains fk_rails_c51bdfc65a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grains
    ADD CONSTRAINT fk_rails_c51bdfc65a FOREIGN KEY (ventral_id) REFERENCES public.figures(id);


--
-- Name: genetics fk_rails_ca69f6ded2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genetics
    ADD CONSTRAINT fk_rails_ca69f6ded2 FOREIGN KEY (skeleton_id) REFERENCES public.skeletons(id);


--
-- Name: text_items fk_rails_f8547942a2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.text_items
    ADD CONSTRAINT fk_rails_f8547942a2 FOREIGN KEY (page_id) REFERENCES public.upload_items(id);


--
-- PostgreSQL database dump complete
--

