\restrict vKwBF9deKGP5GTA0MQC5L4WWD2h2CxNuefHV00PBifwikdEnBAFMciSjICS2YvG

-- Dumped from database version 15.14 (Homebrew)
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: contents_score(bigint[], bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.contents_score(a bigint[], b bigint) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
        SELECT jaccard_index(
          a,
          ARRAY(
            SELECT content_tags.tag_id
            FROM contents
            JOIN content_tags ON content_tags.content_id = contents.id
            WHERE contents.id = b
          )
        )
      $$;


--
-- Name: jaccard_index(bigint[], bigint[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.jaccard_index(a bigint[], b bigint[]) RETURNS double precision
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
          SELECT
              CASE
                  WHEN union_count = 0 THEN 0.0
                  ELSE intersection_count::double precision / union_count::double precision
              END
          FROM (
              SELECT
                  (SELECT COUNT(*) FROM (
                      SELECT unnest(a) INTERSECT SELECT unnest(b)
                  ) AS intersection) AS intersection_count,
                  (SELECT COUNT(*) FROM (
                      SELECT unnest(a) UNION SELECT unnest(b)
                  ) AS union_set) AS union_count
          ) AS counts;
      $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: content_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_tags (
    id bigint NOT NULL,
    content_id bigint NOT NULL,
    tag_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    category integer
);


--
-- Name: content_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.content_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.content_tags_id_seq OWNED BY public.content_tags.id;


--
-- Name: contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contents (
    id bigint NOT NULL,
    format integer,
    title character varying,
    date_of_release character varying,
    creator character varying,
    description text,
    duration integer,
    image_url character varying,
    popularity_score double precision,
    is_processed timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contents_id_seq OWNED BY public.contents.id;


--
-- Name: provider_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider_records (
    id bigint NOT NULL,
    provider_name character varying,
    provider_content_id character varying,
    content_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: provider_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.provider_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: provider_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.provider_records_id_seq OWNED BY public.provider_records.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: content_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tags ALTER COLUMN id SET DEFAULT nextval('public.content_tags_id_seq'::regclass);


--
-- Name: contents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contents ALTER COLUMN id SET DEFAULT nextval('public.contents_id_seq'::regclass);


--
-- Name: provider_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_records ALTER COLUMN id SET DEFAULT nextval('public.provider_records_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: content_tags content_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tags
    ADD CONSTRAINT content_tags_pkey PRIMARY KEY (id);


--
-- Name: contents contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contents
    ADD CONSTRAINT contents_pkey PRIMARY KEY (id);


--
-- Name: provider_records provider_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_records
    ADD CONSTRAINT provider_records_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: index_content_tags_on_content_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_content_tags_on_content_id ON public.content_tags USING btree (content_id);


--
-- Name: index_content_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_content_tags_on_tag_id ON public.content_tags USING btree (tag_id);


--
-- Name: index_provider_records_on_content_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_provider_records_on_content_id ON public.provider_records USING btree (content_id);


--
-- Name: content_tags fk_rails_033f617687; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tags
    ADD CONSTRAINT fk_rails_033f617687 FOREIGN KEY (content_id) REFERENCES public.contents(id);


--
-- Name: content_tags fk_rails_8b91f3a2e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tags
    ADD CONSTRAINT fk_rails_8b91f3a2e3 FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: provider_records fk_rails_fcfff7f93d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_records
    ADD CONSTRAINT fk_rails_fcfff7f93d FOREIGN KEY (content_id) REFERENCES public.contents(id);


--
-- PostgreSQL database dump complete
--

\unrestrict vKwBF9deKGP5GTA0MQC5L4WWD2h2CxNuefHV00PBifwikdEnBAFMciSjICS2YvG

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20251208173541'),
('20251204184253'),
('20251203210100'),
('20251203173404'),
('20251203172828'),
('20251203172000'),
('20251203171019');

