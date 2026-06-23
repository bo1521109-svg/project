--
-- PostgreSQL database dump
--

\restrict ZewGAMgqew6uDlpphPVgumlMvUKpeqYgWAVZRbwH1Zdsc7tSUIzfhivULayvM4z

-- Dumped from database version 15.17 (Debian 15.17-1.pgdg13+1)
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

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
-- Name: dict_category; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.dict_category (
    id integer NOT NULL,
    code character varying(100) NOT NULL,
    name_zh character varying(200) NOT NULL,
    name_en character varying(200),
    parent_id integer,
    level integer,
    platform_code character varying(50),
    is_active boolean,
    sort_order integer
);


ALTER TABLE public.dict_category OWNER TO myuser;

--
-- Name: COLUMN dict_category.id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.id IS '主键';


--
-- Name: COLUMN dict_category.code; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.code IS '类目代码（如：beauty, beauty-makeup）';


--
-- Name: COLUMN dict_category.name_zh; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.name_zh IS '中文名称';


--
-- Name: COLUMN dict_category.name_en; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.name_en IS '英文名称';


--
-- Name: COLUMN dict_category.parent_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.parent_id IS '父类目ID（NULL表示一级类目）';


--
-- Name: COLUMN dict_category.level; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.level IS '层级（1=一级类目，2=二级类目）';


--
-- Name: COLUMN dict_category.platform_code; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.platform_code IS '所属平台（NULL表示全平台共用）';


--
-- Name: COLUMN dict_category.is_active; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.is_active IS '是否启用';


--
-- Name: COLUMN dict_category.sort_order; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_category.sort_order IS '排序顺序';


--
-- Name: dict_category_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.dict_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dict_category_id_seq OWNER TO myuser;

--
-- Name: dict_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.dict_category_id_seq OWNED BY public.dict_category.id;


--
-- Name: dict_country; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.dict_country (
    id integer NOT NULL,
    code character varying(10) NOT NULL,
    name_zh character varying(100) NOT NULL,
    name_en character varying(100) NOT NULL,
    region character varying(50),
    is_active boolean,
    sort_order integer
);


ALTER TABLE public.dict_country OWNER TO myuser;

--
-- Name: COLUMN dict_country.id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_country.id IS '主键';


--
-- Name: COLUMN dict_country.code; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_country.code IS '国家代码（ISO 3166-1，如：US, CN）';


--
-- Name: COLUMN dict_country.name_zh; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_country.name_zh IS '中文名称';


--
-- Name: COLUMN dict_country.name_en; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_country.name_en IS '英文名称';


--
-- Name: COLUMN dict_country.region; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_country.region IS '区域分组（如：北美、东南亚）';


--
-- Name: COLUMN dict_country.is_active; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_country.is_active IS '是否启用';


--
-- Name: COLUMN dict_country.sort_order; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_country.sort_order IS '排序顺序';


--
-- Name: dict_country_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.dict_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dict_country_id_seq OWNER TO myuser;

--
-- Name: dict_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.dict_country_id_seq OWNED BY public.dict_country.id;


--
-- Name: dict_platform; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.dict_platform (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name_zh character varying(100) NOT NULL,
    name_en character varying(100),
    is_active boolean,
    sort_order integer,
    description text
);


ALTER TABLE public.dict_platform OWNER TO myuser;

--
-- Name: COLUMN dict_platform.id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_platform.id IS '主键';


--
-- Name: COLUMN dict_platform.code; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_platform.code IS '平台代码（如：shopify, tiktok）';


--
-- Name: COLUMN dict_platform.name_zh; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_platform.name_zh IS '中文名称';


--
-- Name: COLUMN dict_platform.name_en; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_platform.name_en IS '英文名称';


--
-- Name: COLUMN dict_platform.is_active; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_platform.is_active IS '是否启用';


--
-- Name: COLUMN dict_platform.sort_order; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_platform.sort_order IS '排序顺序';


--
-- Name: COLUMN dict_platform.description; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.dict_platform.description IS '平台描述';


--
-- Name: dict_platform_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.dict_platform_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dict_platform_id_seq OWNER TO myuser;

--
-- Name: dict_platform_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.dict_platform_id_seq OWNED BY public.dict_platform.id;


--
-- Name: login_logs; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.login_logs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    login_at timestamp with time zone DEFAULT now(),
    ip_address character varying(45)
);


ALTER TABLE public.login_logs OWNER TO myuser;

--
-- Name: COLUMN login_logs.id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.login_logs.id IS '日志ID';


--
-- Name: COLUMN login_logs.user_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.login_logs.user_id IS '用户ID（外键）';


--
-- Name: COLUMN login_logs.login_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.login_logs.login_at IS '登录时间';


--
-- Name: COLUMN login_logs.ip_address; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.login_logs.ip_address IS 'IP地址（支持IPv6）';


--
-- Name: login_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.login_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.login_logs_id_seq OWNER TO myuser;

--
-- Name: login_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.login_logs_id_seq OWNED BY public.login_logs.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.product (
    id integer NOT NULL,
    store_id integer NOT NULL,
    title character varying(500) NOT NULL,
    url character varying(500) NOT NULL,
    price double precision,
    currency character varying(10),
    image_url character varying(500),
    sales_estimate integer,
    captured_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    category character varying(255),
    last_stock integer,
    is_available boolean,
    last_available boolean,
    status_change_at timestamp without time zone,
    sales_7d integer DEFAULT 0,
    sales_total integer DEFAULT 0,
    category_code character varying(100),
    platform_code character varying(50),
    data_source character varying(50)
);


ALTER TABLE public.product OWNER TO myuser;

--
-- Name: COLUMN product.id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.id IS '主键';


--
-- Name: COLUMN product.store_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.store_id IS '外键';


--
-- Name: COLUMN product.title; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.title IS '商品标题';


--
-- Name: COLUMN product.url; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.url IS '唯一索引';


--
-- Name: COLUMN product.price; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.price IS '价格';


--
-- Name: COLUMN product.currency; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.currency IS '默认 USD';


--
-- Name: COLUMN product.image_url; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.image_url IS '图片链接';


--
-- Name: COLUMN product.sales_estimate; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.sales_estimate IS '整数，默认 0';


--
-- Name: COLUMN product.captured_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.captured_at IS '抓取时间';


--
-- Name: COLUMN product.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.created_at IS '创建时间';


--
-- Name: COLUMN product.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.updated_at IS '更新时间';


--
-- Name: COLUMN product.last_stock; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.product.last_stock IS '上次库存数（用于计算销量）';


--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_seq OWNER TO myuser;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: store; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.store (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(500) NOT NULL,
    platform character varying(50),
    country character varying(100),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    is_crawling boolean DEFAULT false NOT NULL,
    last_crawl_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    sales_7d integer DEFAULT 0,
    sales_total integer DEFAULT 0,
    platform_code character varying(50),
    country_code character varying(10),
    data_source character varying(50),
    target_country_code character varying(10),
    target_category_code character varying(100),
    is_manual_reviewed boolean DEFAULT false
);


ALTER TABLE public.store OWNER TO myuser;

--
-- Name: COLUMN store.id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.id IS '主键';


--
-- Name: COLUMN store.name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.name IS '店铺名';


--
-- Name: COLUMN store.url; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.url IS '唯一索引';


--
-- Name: COLUMN store.platform; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.platform IS '默认 shopify';


--
-- Name: COLUMN store.country; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.country IS '国家';


--
-- Name: COLUMN store.status; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.status IS 'active/paused/error';


--
-- Name: COLUMN store.is_crawling; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.is_crawling IS '布尔值';


--
-- Name: COLUMN store.last_crawl_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.last_crawl_at IS '最后爬取时间';


--
-- Name: COLUMN store.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.created_at IS '创建时间';


--
-- Name: COLUMN store.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.updated_at IS '更新时间';


--
-- Name: COLUMN store.target_country_code; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.target_country_code IS '任务配置：目标国家代码';


--
-- Name: COLUMN store.target_category_code; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.target_category_code IS '任务配置：目标类目代码';


--
-- Name: COLUMN store.is_manual_reviewed; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.store.is_manual_reviewed IS '是否人工复核过';


--
-- Name: store_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_id_seq OWNER TO myuser;

--
-- Name: store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.store_id_seq OWNED BY public.store.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    phone character varying(20),
    invitation_code character varying(20) NOT NULL,
    invited_by integer,
    created_at timestamp with time zone DEFAULT now(),
    role character varying(20) DEFAULT 'user'::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO myuser;

--
-- Name: COLUMN users.id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.users.id IS '用户ID';


--
-- Name: COLUMN users.username; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.users.username IS '用户名（唯一）';


--
-- Name: COLUMN users.password_hash; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.users.password_hash IS '密码哈希（加密存储）';


--
-- Name: COLUMN users.phone; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.users.phone IS '手机号（可选）';


--
-- Name: COLUMN users.invitation_code; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.users.invitation_code IS '邀请码（唯一，自动生成）';


--
-- Name: COLUMN users.invited_by; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.users.invited_by IS '邀请人ID（外键，指向邀请人）';


--
-- Name: COLUMN users.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.users.created_at IS '创建时间';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO myuser;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: dict_category id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dict_category ALTER COLUMN id SET DEFAULT nextval('public.dict_category_id_seq'::regclass);


--
-- Name: dict_country id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dict_country ALTER COLUMN id SET DEFAULT nextval('public.dict_country_id_seq'::regclass);


--
-- Name: dict_platform id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dict_platform ALTER COLUMN id SET DEFAULT nextval('public.dict_platform_id_seq'::regclass);


--
-- Name: login_logs id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.login_logs ALTER COLUMN id SET DEFAULT nextval('public.login_logs_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Name: store id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.store ALTER COLUMN id SET DEFAULT nextval('public.store_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: dict_category; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.dict_category (id, code, name_zh, name_en, parent_id, level, platform_code, is_active, sort_order) FROM stdin;
1	all	全部	\N	\N	1	\N	t	0
2	beauty	美妆个护	\N	\N	1	\N	t	1
3	beauty-makeup	美妆	\N	2	2	\N	t	1
4	beauty-skincare	美容护肤	\N	2	2	\N	t	2
5	beauty-hair	头部护理与造型	\N	2	2	\N	t	3
6	beauty-nail	手足及指甲护理	\N	2	2	\N	t	4
7	beauty-bath	洗浴与身体护理	\N	2	2	\N	t	5
8	beauty-men	男士护理	\N	2	2	\N	t	6
9	beauty-appliance	美容、个护电器	\N	2	2	\N	t	7
10	beauty-eye-ear	眼镜耳朵护理	\N	2	2	\N	t	8
11	beauty-nose-mouth	鼻子口腔护理	\N	2	2	\N	t	9
12	beauty-women-private	女性私密处护理	\N	2	2	\N	t	10
13	beauty-special	特殊个护	\N	2	2	\N	t	11
14	beauty-perfume	香水	\N	2	2	\N	t	12
15	women-fashion	女装与女士内衣	\N	\N	1	\N	t	2
16	women-tops	女士上装	\N	15	2	\N	t	1
17	women-bottoms	女士下装	\N	15	2	\N	t	2
18	women-dresses	女士连衣裙	\N	15	2	\N	t	3
19	women-special	女士特殊服饰	\N	15	2	\N	t	4
20	women-suits	女士套装与连体衣	\N	15	2	\N	t	5
21	women-underwear	女士内衣	\N	15	2	\N	t	6
22	women-sleepwear	女士睡衣和家居服	\N	15	2	\N	t	7
23	health	保健	\N	\N	1	\N	t	3
24	health-food	保健食品	\N	23	2	\N	t	1
25	health-medical	医疗保健	\N	23	2	\N	t	2
26	health-otc	非处方药物与疗法	\N	23	2	\N	t	3
27	health-alternative	另类医疗	\N	23	2	\N	t	4
28	health-adult	情趣用品	\N	23	2	\N	t	5
29	fashion-accessories	时尚配件	\N	\N	1	\N	t	4
30	accessories-wigs	假发	\N	29	2	\N	t	1
31	accessories-fabric	服装布料	\N	29	2	\N	t	2
32	accessories-clothing	服饰配件	\N	29	2	\N	t	3
33	accessories-glasses	眼镜	\N	29	2	\N	t	4
34	accessories-watches	手表与配件	\N	29	2	\N	t	5
35	accessories-jewelry	平价饰品	\N	29	2	\N	t	6
36	accessories-hair	发饰	\N	29	2	\N	t	7
37	sports	运动与户外	\N	\N	1	\N	t	5
38	sports-clothing	运动服饰	\N	37	2	\N	t	1
39	sports-shoes	运动鞋	\N	37	2	\N	t	2
40	sports-accessories	运动与户外配件	\N	37	2	\N	t	3
41	sports-ball	球类运动设备	\N	37	2	\N	t	4
42	sports-water	水上运动设备	\N	37	2	\N	t	5
43	sports-winter	冬季运动设备	\N	37	2	\N	t	6
44	sports-camping	露营与徒步设备	\N	37	2	\N	t	7
45	sports-fitness	健身设备	\N	37	2	\N	t	8
46	sports-leisure	休闲与室外休闲设备	\N	37	2	\N	t	9
47	sports-fan	球迷周边	\N	37	2	\N	t	10
48	sports-swimwear	泳装&冲浪服&潜水服	\N	37	2	\N	t	11
49	second-hand	二手	\N	\N	1	\N	t	28
50	second-hand-trading-cards	收藏交易卡	\N	49	2	\N	t	1
51	second-hand-fashion-accessories	时尚配饰	\N	49	2	\N	t	2
52	second-hand-bags	包	\N	49	2	\N	t	3
53	second-hand-shoes	鞋类	\N	49	2	\N	t	4
54	second-hand-men-clothing	男士服装	\N	49	2	\N	t	5
55	second-hand-women-clothing	女士服装	\N	49	2	\N	t	6
56	second-hand-electronics	翻新手机和电子产品	\N	49	2	\N	t	7
57	second-hand-luggage	行李箱和旅行用品	\N	49	2	\N	t	8
58	second-hand-watches	手表	\N	49	2	\N	t	9
59	virtual	虚拟商品	\N	\N	1	shopify	t	29
60	virtual-telecom	电信	\N	59	2	shopify	t	1
61	pod-custom	POD定制	\N	\N	1	\N	t	30
62	adult-products	成人用品	\N	\N	1	\N	t	31
63	culture	文化	\N	\N	1	\N	t	32
\.


--
-- Data for Name: dict_country; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.dict_country (id, code, name_zh, name_en, region, is_active, sort_order) FROM stdin;
1	US	美国	United States	北美	t	1
2	ID	印度尼西亚	Indonesia	东南亚	t	2
3	GB	英国	United Kingdom	欧洲	t	3
4	VN	越南	Vietnam	东南亚	t	4
5	TH	泰国	Thailand	东南亚	t	5
6	MY	马来西亚	Malaysia	东南亚	t	6
7	PH	菲律宾	Philippines	东南亚	t	7
8	ES	西班牙	Spain	欧洲	t	8
9	MX	墨西哥	Mexico	拉美	t	9
10	DE	德国	Germany	欧洲	t	10
11	FR	法国	France	欧洲	t	11
12	IT	意大利	Italy	欧洲	t	12
13	BR	巴西	Brazil	拉美	t	13
14	JP	日本	Japan	东亚	t	14
15	SG	新加坡	Singapore	东南亚	t	15
\.


--
-- Data for Name: dict_platform; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.dict_platform (id, code, name_zh, name_en, is_active, sort_order, description) FROM stdin;
1	shopify	Shopify独立站	Shopify	t	1	\N
2	tiktok	TikTok电商	TikTok	t	2	\N
3	content	内容创作	Content Creation	t	3	\N
\.


--
-- Data for Name: login_logs; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.login_logs (id, user_id, login_at, ip_address) FROM stdin;
8	2	2026-04-09 09:42:06.48115+00	\N
9	2	2026-04-09 09:42:40.542642+00	\N
10	2	2026-04-09 09:43:16.653744+00	\N
11	2	2026-04-09 09:44:33.116033+00	\N
12	2	2026-04-09 09:46:17.213235+00	\N
13	2	2026-04-09 09:46:50.150244+00	\N
14	2	2026-04-09 09:49:47.818939+00	\N
15	3	2026-04-09 09:57:36.418114+00	\N
16	3	2026-04-09 10:26:10.964791+00	\N
17	3	2026-04-09 10:34:52.51499+00	\N
18	2	2026-04-09 10:38:11.678291+00	\N
19	2	2026-04-09 10:58:51.283281+00	\N
20	3	2026-04-09 10:59:13.268077+00	\N
21	3	2026-04-09 11:09:44.827353+00	\N
22	2	2026-04-09 11:15:49.97865+00	\N
23	2	2026-04-09 11:16:40.895463+00	\N
24	3	2026-04-10 10:23:44.791189+00	\N
25	3	2026-04-11 04:16:50.786196+00	\N
26	4	2026-04-11 06:15:47.830156+00	\N
27	4	2026-04-11 07:53:26.810101+00	\N
28	4	2026-04-11 07:54:48.650477+00	\N
29	2	2026-04-13 10:38:12.101576+00	\N
30	3	2026-04-13 10:38:43.963275+00	\N
31	2	2026-04-14 10:25:40.39543+00	\N
32	3	2026-04-14 10:26:07.890109+00	\N
33	3	2026-04-16 07:17:49.889832+00	\N
34	2	2026-04-16 08:43:56.786044+00	\N
35	2	2026-04-16 08:50:34.274883+00	\N
36	2	2026-04-16 08:56:19.693993+00	\N
37	2	2026-04-16 09:45:09.452497+00	\N
38	3	2026-04-16 10:44:18.422612+00	\N
39	2	2026-04-17 09:16:25.732972+00	\N
40	2	2026-04-18 08:13:24.899051+00	\N
41	2	2026-04-18 08:14:55.232396+00	\N
42	2	2026-04-18 08:15:52.220759+00	\N
43	2	2026-04-18 08:25:11.386849+00	\N
44	2	2026-04-18 08:30:09.319242+00	\N
45	3	2026-04-18 08:35:12.578301+00	\N
46	2	2026-04-18 08:35:26.078069+00	\N
47	3	2026-04-18 08:51:33.414193+00	\N
48	2	2026-04-18 08:56:57.04778+00	\N
49	3	2026-04-18 10:57:36.318968+00	\N
50	2	2026-04-18 11:01:10.466076+00	\N
51	3	2026-04-20 05:51:24.959735+00	\N
52	2	2026-04-21 06:28:19.959558+00	\N
53	2	2026-04-24 02:27:54.504986+00	\N
54	3	2026-04-24 07:02:55.676027+00	\N
55	2	2026-04-24 07:04:22.36116+00	\N
56	3	2026-04-24 07:18:32.654322+00	\N
57	2	2026-04-24 07:19:05.021862+00	\N
58	2	2026-04-24 07:19:32.952042+00	\N
59	2	2026-04-24 07:25:24.76335+00	\N
60	3	2026-04-24 07:25:41.949915+00	\N
61	2	2026-04-24 07:26:27.630297+00	\N
62	3	2026-04-24 07:27:00.185093+00	\N
63	2	2026-04-24 11:08:00.401802+00	\N
64	2	2026-04-24 11:10:06.450304+00	\N
65	3	2026-05-06 03:03:41.53481+00	\N
66	2	2026-05-06 08:29:11.253277+00	\N
67	2	2026-05-07 03:04:18.306799+00	\N
68	2	2026-05-14 03:10:52.135088+00	\N
69	2	2026-05-15 03:30:09.747027+00	\N
70	2	2026-05-15 03:45:34.966141+00	\N
71	2	2026-05-15 03:45:54.04949+00	\N
72	2	2026-05-15 03:46:03.081928+00	\N
73	2	2026-05-15 03:46:27.404779+00	\N
74	2	2026-05-15 07:30:49.313415+00	\N
75	2	2026-05-15 08:38:25.898805+00	\N
76	2	2026-05-15 08:41:16.30987+00	\N
77	2	2026-05-23 02:15:36.538057+00	\N
78	2	2026-05-25 08:29:10.050501+00	\N
79	3	2026-05-26 10:49:20.667216+00	\N
80	2	2026-05-26 10:49:39.9912+00	\N
81	3	2026-05-28 08:27:58.953273+00	\N
82	2	2026-05-28 08:28:27.684559+00	\N
83	2	2026-06-01 08:30:04.361462+00	\N
84	2	2026-06-06 09:16:30.221234+00	\N
85	2	2026-06-15 02:08:40.035022+00	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.product (id, store_id, title, url, price, currency, image_url, sales_estimate, captured_at, created_at, updated_at, category, last_stock, is_available, last_available, status_change_at, sales_7d, sales_total, category_code, platform_code, data_source) FROM stdin;
1140	21	The Box-Cut Tee in Essential Cotton | Heathered Oats | No Pocket	https://everlane.com/products/womens-organic-cotton-box-cut-tee-heathered-oats	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/a4c13146_6a11.jpg?v=1778094003	0	2026-05-07 03:04:37.761235	2026-05-07 03:04:37.779348	2026-05-07 03:04:37.779348	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1149	21	Denim Jort | Medium Dark Indigo	https://everlane.com/products/mens-denim-jort-medium-dark-indigo	118	USD	\N	0	2026-05-07 03:04:37.768738	2026-05-07 03:04:37.779353	2026-05-07 03:04:37.779353	Denim	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1291	47	Niao Suan Ping 尿酸平 60pills	https://nytrt.com/products/niao-suan-ping-60pills	10.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/NiaoSuanPing.png?v=1768407772	0	2026-05-15 03:52:00.075756	2026-05-15 03:52:00.079636	2026-05-15 04:48:38.203828	dampness	\N	t	t	\N	0	0	health-medical	shopify	backfill
1292	47	Gong Xue Ning 宫血宁 20pills	https://nytrt.com/products/gong-xue-ning-20pills	8.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/GongXueNing.png?v=1768407561	0	2026-05-15 03:52:00.076156	2026-05-15 03:52:00.079636	2026-05-15 04:48:38.203828	pregnancy	\N	t	t	\N	0	0	health-medical	shopify	backfill
1293	47	Ya Tong Lin 牙痛灵（美国制造) 100pills	https://nytrt.com/products/ya-tong-lin-100pills	10.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/YaTongLin.png?v=1768407416	0	2026-05-15 03:52:00.07658	2026-05-15 03:52:00.079637	2026-05-15 04:48:38.203828	toothache	\N	t	t	\N	0	0	health-medical	shopify	backfill
1294	47	Depression Formula 抗忧郁片 60 pills	https://nytrt.com/products/depression-formula-60-pills	10.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/Depression_Formula_-Photoroom.png?v=1768409090	0	2026-05-15 03:52:00.076979	2026-05-15 03:52:00.079638	2026-05-15 04:48:38.203828	brain	\N	t	t	\N	0	0	health-medical	shopify	backfill
1295	47	Jia Wei Xiao Yao Wan 仙鹤牌加味逍遥丸 240Pills	https://nytrt.com/products/jia-wei-xiao-yao-wan-240pills	12.8	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/08d2d14fc1b71d3650b46105f1f2ae16_66d9a3fc-087d-4ea0-9e2e-27bcea92d2bf.jpg?v=1768340627	0	2026-05-15 03:52:00.077363	2026-05-15 03:52:00.079639	2026-05-15 04:48:38.203828	Storkbrand	\N	t	t	\N	0	0	health-medical	shopify	backfill
1296	47	Jian Pi Wei Ke Li 昆中药参苓健脾胃颗粒 10bags	https://nytrt.com/products/jian-pi-wei-ke-li	13	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/d95b5c1d638a47229138489e297360fe.png_syp.jpg?v=1768339291	0	2026-05-15 03:52:00.077781	2026-05-15 03:52:00.079639	2026-05-15 04:48:38.203828	digestion	\N	t	t	\N	0	0	health-medical	shopify	backfill
1267	47	Wei An Jie Yang Wan 伟安解痒丸 30 Capsules	https://nytrt.com/products/wei-an-jie-yang-wan-30-capsules	19	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/1_04b768e3-abfb-4542-8eee-55c201dbf2d2.png?v=1772124061	0	2026-05-15 03:52:00.062305	2026-05-15 03:52:00.079623	2026-05-15 04:48:38.203828	skin	\N	t	t	\N	0	0	health-medical	shopify	backfill
1268	47	Du Huo 独活	https://nytrt.com/products/du-huo	3.5	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/5e817082d4556a2d866acf3d1aa5c7a1-Photoroom.png?v=1771973526	0	2026-05-15 03:52:00.0641	2026-05-15 03:52:00.079624	2026-05-15 04:48:38.203828	herb	\N	t	t	\N	0	0	health-medical	shopify	backfill
1269	47	Hou Bu 厚补	https://nytrt.com/products/hou-bu	3.5	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/downloaded-image_1.jpg?v=1771973270	0	2026-05-15 03:52:00.064822	2026-05-15 03:52:00.079624	2026-05-15 04:48:38.203828	herb	\N	t	t	\N	0	0	health-medical	shopify	backfill
1270	47	Shen Jin Cao 伸筋草	https://nytrt.com/products/shen-jin-cao	2.5	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/3_360289cc-23b0-4066-b780-59a4a93652b6.jpg?v=1771973066	0	2026-05-15 03:52:00.065451	2026-05-15 03:52:00.079625	2026-05-15 04:48:38.203828	herb	\N	t	t	\N	0	0	health-medical	shopify	backfill
1271	47	E Shu 莪术	https://nytrt.com/products/e-shu	3	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/EShu.png?v=1771967773	0	2026-05-15 03:52:00.066028	2026-05-15 03:52:00.079625	2026-05-15 04:48:38.203828	herb	\N	t	t	\N	0	0	health-medical	shopify	backfill
1272	47	Huang Lian Shang Qing 同仁堂黄连上清丸 10Balls	https://nytrt.com/products/huang-lian-shang-qing-10balls	8.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/4_3689df9a-8fb4-4f33-93cc-2a6f32fba16e.png?v=1771946663	0	2026-05-15 03:52:00.066656	2026-05-15 03:52:00.079626	2026-05-15 04:48:38.203828	BJTRT	\N	t	t	\N	0	0	health-medical	shopify	backfill
1273	47	Tong Xuan Li Fei 同仁堂通宣理肺丸 10Balls	https://nytrt.com/products/tong-xuan-li-fei	11.5	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/3_605becf7-a1fd-4c64-8d8a-93c246a5c9d4.png?v=1771946246	0	2026-05-15 03:52:00.067256	2026-05-15 03:52:00.079627	2026-05-15 04:48:38.203828	BJTRT	\N	t	t	\N	0	0	health-medical	shopify	backfill
1274	47	Yi Qi Yang Xue 华药堂 益气养血口服液 10Pieces	https://nytrt.com/products/yi-qi-yang-xue-10pieces	11.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/YiQiYangXue.png?v=1771529071	0	2026-05-15 03:52:00.067848	2026-05-15 03:52:00.079627	2026-05-15 04:48:38.203828	gift	\N	t	t	\N	0	0	health-medical	shopify	backfill
1275	47	Qing Yan Pian 清咽片 40Pills	https://nytrt.com/products/qing-yan-pian-40pills	6.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/QingYanPian.png?v=1771528738	0	2026-05-15 03:52:00.068409	2026-05-15 03:52:00.079628	2026-05-15 04:48:38.203828	Cold	\N	t	t	\N	0	0	health-medical	shopify	backfill
1276	47	Pu Di Lan Xiao Yan Ye 蒲地蓝消炎口服液 6Piece	https://nytrt.com/products/pu-di-lan-xiao-yan-ye	10.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/Pu_Di_Lan_Xiao_Yan_Ye_5.png?v=1771528497	0	2026-05-15 03:52:00.068912	2026-05-15 03:52:00.079628	2026-05-15 04:48:38.203828	Cold	\N	t	t	\N	0	0	health-medical	shopify	backfill
1277	47	Flavor-Fried Broad Beans 风味炸蚕豆 ( 超推荐！)	https://nytrt.com/products/flavor-fried-broad-beans	7	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/68f9e46211933953296f4e2ee6fee3aa.png?v=1771453429	0	2026-05-15 03:52:00.069363	2026-05-15 03:52:00.079629	2026-05-15 04:48:38.203828	__label:Best Seller	\N	t	t	\N	0	0	health-medical	shopify	backfill
1278	47	Wei C Yin Qiao Ke Li 白云山维C银翘颗粒 15bags	https://nytrt.com/products/wei-c-yin-qiao-ke-li-c	8.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/C.png?v=1770912565	0	2026-05-15 03:52:00.069817	2026-05-15 03:52:00.079629	2026-05-15 04:48:38.203828	Cold	\N	t	t	\N	0	0	health-medical	shopify	backfill
1279	47	Fu Zi Li Zhong 同仁堂附子理中丸 30g	https://nytrt.com/products/fu-zi-li-zhong-30g	7.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/2_f62486e6-0e22-4e89-b81c-94231075a600.png?v=1770910617	0	2026-05-15 03:52:00.070293	2026-05-15 03:52:00.07963	2026-05-15 04:48:38.203828	BJTRT	\N	f	f	\N	0	0	health-medical	shopify	backfill
1280	47	Xiao Chai Hu Ke Li 白云山小柴胡颗粒12bags (无糖）	https://nytrt.com/products/xiao-chai-hu-ke-li-12bags	9.5	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/XiaoChaiHuKeLi_12bags.png?v=1770676132	0	2026-05-15 03:52:00.070724	2026-05-15 03:52:00.07963	2026-05-15 04:48:38.203828	baiyunshan	\N	f	f	\N	0	0	health-medical	shopify	backfill
1281	47	Liao Shen （ Liao Sea Cucumber）正宗辽参海参	https://nytrt.com/products/liao-shen	184	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/3_da0ec202-b065-4636-a010-b8c86fc8ed25.jpg?v=1770671433	0	2026-05-15 03:52:00.071196	2026-05-15 03:52:00.079631	2026-05-15 04:48:38.203828	food	\N	t	t	\N	0	0	health-medical	shopify	backfill
1282	47	Bai Tou Weng Tang 仙鹤牌白头翁汤 240Pills	https://nytrt.com/products/bai-tou-weng-tang-240pills	12.5	USD	https://cdn.shopify.com/s/files/1/1220/8124/products/240pills_1_-08.jpg?v=1611267936	0	2026-05-15 03:52:00.071673	2026-05-15 03:52:00.079631	2026-05-15 04:48:38.203828	Storkbrand	\N	f	f	\N	0	0	health-medical	shopify	backfill
1283	47	黑豆 Dried Black Bean 1LB	https://nytrt.com/products/black-soybeans-1lb	6.5	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/BlackSoybeans2.png?v=1770220561	0	2026-05-15 03:52:00.072121	2026-05-15 03:52:00.079632	2026-05-15 04:48:38.203828	grain	\N	f	f	\N	0	0	health-medical	shopify	backfill
347	5	Face shield	https://thekarelab.com/products/face-shield-b2c	85	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/face-shield-454291.png?v=1648929453	0	2026-05-14 07:20:27.770231	2026-04-11 06:27:34.217652	2026-05-14 07:20:27.777403	Work Safety Protective Gear	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
348	5	FFP2 NR Face Mask x 30	https://thekarelab.com/products/ffp2-nr-face-mask-x-30-b2c	248	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/ffp2-nr-face-mask-x-30-374261.png?v=1648929453	0	2026-05-14 07:20:27.770701	2026-04-11 06:27:34.217653	2026-05-14 07:20:27.777403	Medical Masks	\N	f	\N	\N	0	0	health	shopify	m004|keyword_ma|80
1284	47	Peru Premium Maca 玛咖 100Capsules	https://nytrt.com/products/peru-premium-maca-100capsules	48	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/8fd4fa99f4cc0986f9459a66fe37b776.png?v=1770157153	0	2026-05-15 03:52:00.072603	2026-05-15 03:52:00.079632	2026-05-15 04:48:38.203828	Personal Care	\N	t	t	\N	0	0	health-medical	shopify	backfill
1285	47	Niu Pi Xuan 美国老威牌牛皮癣 60Tablets	https://nytrt.com/products/niu-pi-xuan	10.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/5d4fe7ad6db45508c1aa1b4f96a5fa7a.png?v=1770156883	0	2026-05-15 03:52:00.073139	2026-05-15 03:52:00.079633	2026-05-15 04:48:38.203828	skin	\N	t	t	\N	0	0	health-medical	shopify	backfill
1286	47	Mai Tong 美国老威牌脉通 100Pills	https://nytrt.com/products/mai-tong	12.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/1_0edaf7c8-a4c2-4946-9839-ca44e9b5b77e.png?v=1770156543	0	2026-05-15 03:52:00.07361	2026-05-15 03:52:00.079633	2026-05-15 04:48:38.203828	blood circulation	\N	t	t	\N	0	0	health-medical	shopify	backfill
353	5	5 Layers PM 2.5 Carbon Mask Filters For Adult Cloth Mask	https://thekarelab.com/products/5-layers-pm-2-5-carbon-mask-filters-for-adult-cloth-mask-b2c	32	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/5-layers-pm-25-carbon-mask-filters-for-adult-cloth-mask-194807.png?v=1648453571	0	2026-05-14 07:20:27.772805	2026-04-11 06:27:34.217657	2026-05-14 07:20:27.777404	Masks	\N	f	\N	\N	0	0	adult-products	shopify	m004|keyword_ma|80
629	21	Pointed-Toe Slingback Heel | Snow	https://everlane.com/products/womens-pointed-toe-slingback-heel-snow	228	USD	\N	0	2026-04-16 10:38:40.031151	2026-04-16 10:29:07.014608	2026-04-16 10:38:40.048703	Flats + Other	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1287	47	Jian Pi Yi Chang Wan 健脾益肠丸 100Pills	https://nytrt.com/products/jian-pi-yi-chang-wan-100p	10.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/JianPiYiChangWan_-Photoroom_a46ebd72-23b4-43e6-8cf9-e12bf8f499f8.png?v=1768409818	0	2026-05-15 03:52:00.074061	2026-05-15 03:52:00.079634	2026-05-15 04:48:38.203828	spleen	\N	t	t	\N	0	0	health-medical	shopify	backfill
1288	47	Xiao Shui Li Shi Pian 消水利湿片 60Tablets	https://nytrt.com/products/xiao-shui-li-shi-pian-60tablets-1	9.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/fec40fa4053af97230c3c93b938a5db9_e5bde82d-b7b5-4ab6-b564-7b7441e1cb0a.png?v=1768408565	0	2026-05-15 03:52:00.074505	2026-05-15 03:52:00.079634	2026-05-15 04:48:38.203828	dampness	\N	t	t	\N	0	0	health-medical	shopify	backfill
1289	47	Qi Guan Yan Tan Ke Chuan Wan 气管炎痰咳喘丸 60Tablets	https://nytrt.com/products/qi-guan-yan-tan-ke-chuan-wan-60tablets	10.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/4419ee3d65ca4361a571901010a03cae.png?v=1768408293	0	2026-05-15 03:52:00.074942	2026-05-15 03:52:00.079635	2026-05-15 04:48:38.203828	cough	\N	t	t	\N	0	0	health-medical	shopify	backfill
1290	47	Shen Jin Shuai Ruo Pian 神经衰弱片 60Tablets	https://nytrt.com/products/shen-jin-shuai-ruo-pian-60tablets	8.99	USD	https://cdn.shopify.com/s/files/1/1220/8124/files/ShenJinShuaiRuoPian.png?v=1768408168	0	2026-05-15 03:52:00.075344	2026-05-15 03:52:00.079635	2026-05-15 04:48:38.203828	brain	\N	t	t	\N	0	0	health-medical	shopify	backfill
208	9	Silver Aradhana Set	https://www.giva.co/products/silver-aradhana-set	4099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TR0201_A0121_A0121_1-min.jpg?v=1726141176	0	2026-04-10 10:32:37.426199	2026-04-10 10:32:37.428416	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
586	9	Golden Smile Star Kids Anklet (0-1 years)	https://giva.co/products/golden-smile-star-kids-anklet	899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0444_2_ce9dc443-7b9e-4a61-a097-a1ab9f08db1c.jpg?v=1743166596	0	2026-04-14 03:05:45.971965	2026-04-14 03:05:46.001235	2026-05-15 05:09:37.010697	Anklets	\N	t	t	\N	0	0	culture	shopify	backfill
587	9	Silver Pink Square Set	https://giva.co/products/silver-pink-square-set	7099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02640_ER02811_1.jpg?v=1726746931	0	2026-04-14 03:05:45.973203	2026-04-14 03:05:46.001236	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
591	9	Silver Graceful Rope Chain	https://giva.co/products/silver-graceful-rope-chain	3799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLCH074_5.jpg?v=1772449185	0	2026-04-14 03:05:45.981085	2026-04-14 03:05:46.001238	2026-05-15 05:09:37.010697	Trende Chain	\N	t	t	\N	0	0	culture	shopify	backfill
592	9	Silver Met Love Set	https://giva.co/products/silver-met-love-set	8999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02683_ER02967_BR01145_1.jpg?v=1737091185	0	2026-04-14 03:05:45.98196	2026-04-14 03:05:46.001238	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
787	36	LastRound Kit	https://lastobject.com/products/lastround-kit	37	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/products/LastRound_Black-min.jpg?v=1686647037	0	2026-05-14 07:20:40.120893	2026-04-16 10:29:20.122637	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
788	36	Personal Care Kit	https://lastobject.com/products/personal-care-kits	56	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/products/personal-care-kit-bundle-lastobject-163541.jpg?v=1686049010	0	2026-05-14 07:20:40.121272	2026-04-16 10:29:20.122637	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
789	36	LastPad Kit	https://lastobject.com/products/pad-kit	41	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/products/lastpad-kit-bundle-lastobject-234772.jpg?v=1686049294	0	2026-05-14 07:20:40.121689	2026-04-16 10:29:20.122638	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
980	23	Mom-to-Baby Support Ritual*	https://ritual.com/products/mom-to-baby-support-ritual	101	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Essential_-Omega-_-Choline-Trio-for-Prenatal.webp?v=1773186519	0	2026-05-14 07:21:14.105773	2026-04-16 10:29:45.852242	2026-05-15 05:09:37.010697	bundle	\N	t	t	\N	0	0	health	shopify	backfill
981	23	Prenatal Essential Support Ritual*	https://ritual.com/products/prenatal-essential-support-ritual	68	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Mom-to-Baby-Set-for-Prenatal.webp?v=1773186642	0	2026-05-14 07:21:14.10614	2026-04-16 10:29:45.852242	2026-05-15 05:09:37.010697	bundle	\N	t	t	\N	0	0	health	shopify	backfill
982	23	Daily Shake	https://ritual.com/products/essential-protein-daily-shake-18-chocolate	44	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/pdp-hero-PD18-chocolate-01_a51055ea-ef0b-4a51-9c5b-4bd1ee66b793.jpg?v=1771529730	0	2026-05-14 07:21:14.106598	2026-04-16 10:29:45.852243	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
983	23	Help Your Self	https://ritual.com/products/help-your-self-the-new-rules-for-wellness	35	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-Kat-Book.jpg?v=1774551255	0	2026-05-14 07:21:14.107048	2026-04-16 10:29:45.852243	2026-05-15 05:09:37.010697	merch	\N	t	t	\N	0	0	health	shopify	backfill
1141	21	Lightweight Terry Long Shorts | Passion Fruit	https://everlane.com/products/womens-lightweight-terry-long-shorts-passion-fruit	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/ab60eeba_cdba.jpg?v=1778025604	0	2026-05-07 03:04:37.764372	2026-05-07 03:04:37.779349	2026-05-07 03:04:37.779349	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1142	21	Lightweight Terry Long Shorts | Velvet Morning Garment Dye	https://everlane.com/products/womens-lightweight-terry-long-shorts-velvet-morning-garment-dye	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/9b25e9b3_651d.jpg?v=1778025604	0	2026-05-07 03:04:37.765128	2026-05-07 03:04:37.77935	2026-05-07 03:04:37.77935	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1143	21	The Utility Straight-Leg Pant | Dark Forest | 28.5" Inseam	https://everlane.com/products/womens-twill-utility-straight-leg-pant-long-dark-forest	118	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/444f66a4_855a.jpg?v=1778025603	0	2026-05-07 03:04:37.765687	2026-05-07 03:04:37.77935	2026-05-07 03:04:37.77935	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1144	21	Lightweight Terry Long Shorts | Parchment	https://everlane.com/products/womens-lightweight-terry-long-shorts-parchment	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/abe176f4_ec51.jpg?v=1778025603	0	2026-05-07 03:04:37.766268	2026-05-07 03:04:37.779351	2026-05-07 03:04:37.779351	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1145	21	The ReNew Transit Backpack |  Olive	https://everlane.com/products/mens-renew-backpack-olive	118	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/33a6e7f8_3dae.jpg?v=1774382403	0	2026-05-07 03:04:37.766766	2026-05-07 03:04:37.779351	2026-05-07 03:04:37.779351	Bags	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
1146	21	Soyeux Linen Pleated Trouser | Dark Brown	https://everlane.com/products/mens-soyeux-linen-pleated-trouser-dark-brown	168	USD	\N	0	2026-05-07 03:04:37.76729	2026-05-07 03:04:37.779352	2026-05-07 03:04:37.779352	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1147	21	Soyeux Linen Pleated Trouser | Black	https://everlane.com/products/mens-soyeux-linen-pleated-trouser-black	168	USD	\N	0	2026-05-07 03:04:37.767771	2026-05-07 03:04:37.779352	2026-05-07 03:04:37.779352	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1148	21	Soyeux Linen Pleated Trouser | Peyote	https://everlane.com/products/mens-soyeux-linen-pleated-trouser-peyote	168	USD	\N	0	2026-05-07 03:04:37.768245	2026-05-07 03:04:37.779353	2026-05-07 03:04:37.779353	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1150	21	Denim Jort | Light Indigo	https://everlane.com/products/mens-denim-jort-light-indigo	118	USD	\N	0	2026-05-07 03:04:37.769244	2026-05-07 03:04:37.779354	2026-05-07 03:04:37.779354	Denim	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1151	21	Square Tank in Stretch Linen | Black	https://everlane.com/products/womens-square-tank-stretch-linen-2-black	88	USD	\N	0	2026-05-07 03:04:37.76973	2026-05-07 03:04:37.779354	2026-05-07 03:04:37.779354	Woven Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1152	21	Lightweight Denim Easy Short | Medium Indigo	https://everlane.com/products/mens-lightweight-denim-easy-short-medium-indigo	98	USD	\N	0	2026-05-07 03:04:37.770156	2026-05-07 03:04:37.779354	2026-05-07 03:04:37.779355	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
985	23	Natalbiotic™	https://ritual.com/products/natalbiotic	60	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-NTLB-Carousel-01.jpg?v=1770263126	0	2026-05-14 07:21:14.107929	2026-04-16 10:29:45.852244	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
1001	23	HyaCera™	https://ritual.com/products/hyacera-for-skin-hydration	54	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP_HYA_Bottle_1.jpg?v=1770263106	0	2026-05-14 07:21:14.114368	2026-04-16 10:29:45.852253	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
603	34	LINNER Arm exerciser	https://linnerlife.com/products/linner-arm-exerciser	49.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/LINNER_Arm_Exerciser.jpg?v=1774423934	0	2026-05-14 07:21:55.802277	2026-04-16 10:29:04.5547	2026-05-14 07:21:55.816287	Linner	\N	f	f	\N	0	0	sports	shopify	m004|keyword_ma|80
1218	23	The Shaker	https://ritual.com/products/the-shaker	20	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Cart-Shaker.jpg?v=1778195553	0	2026-05-14 07:21:14.097897	2026-05-14 07:21:14.117407	2026-05-15 05:09:37.010697	Goods	\N	t	t	\N	0	0	health	shopify	backfill
940	27	Aura Paper Panel	https://papershoot.com/products/aura-paper-panel	14.8	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/PaperShootCameraAurapaperAmberRoll_12eba7e1-715a-407e-961c-40a237e398ac.jpg?v=1766566507	0	2026-05-14 07:20:29.414756	2026-04-16 10:29:29.298442	2026-05-15 05:09:37.010697	Aura Case	\N	t	t	\N	0	0	culture	shopify	backfill
686	29	Bio-Individual - Nuclear Power Shine-through Dye-Sub PBT Full Keycap Set	https://keychron.com/products/bio-individual-nuclear-power-shine-through-dye-sub-pbt-full-keycap-set	49.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Bio-Individual-Full-Set-Keycap-Set-Features.jpg?v=1773903498	0	2026-04-21 10:23:40.011086	2026-04-16 10:29:10.034079	2026-05-15 05:09:37.010697	Keycaps	\N	f	f	\N	0	0	culture	shopify	backfill
687	29	Arsenal - Nuclear Power Shine-through Dye-Sub PBT Full Keycap Set	https://keychron.com/products/arsenal-nuclear-power-shine-through-dye-sub-pbt-full-keycap-set	49.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Arsenal-Full-Set-Keycap-Set-Features.jpg?v=1773903111	0	2026-04-16 10:29:10.032812	2026-04-16 10:29:10.03408	2026-05-15 05:09:37.010697	Keycaps	\N	t	t	\N	0	0	culture	shopify	backfill
720	37	Ridge KeyCase - Hot Rod	https://ridge.com/products/hot-rod-keycase	75	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/HotRod-Keycase-THUMBNAIL.jpg?v=1774632032	0	2026-04-21 10:23:22.999715	2026-04-16 10:29:16.976836	2026-05-15 05:09:37.010697	EDC - KEYCASE - RIDGE KEYCASE - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
721	37	Ridge KeyCase - Thunderbird	https://ridge.com/products/thunderbird-keycase	75	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Thunderbird-Keycase-THUMBNAIL.jpg?v=1774631736	0	2026-04-21 10:23:23.000967	2026-04-16 10:29:16.976837	2026-05-15 05:09:37.010697	EDC - KEYCASE - RIDGE KEYCASE - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
722	37	Ridge Wallet - Thunderbird	https://ridge.com/products/thunderbird	125	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Thunderbird-Wallet-THUMBNAIL.jpg?v=1774631627	0	2026-04-21 10:23:23.002104	2026-04-16 10:29:16.976837	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
723	37	Ridge Wallet - Mixtape	https://ridge.com/products/mixtape	95	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Mixtape-Wallet-THUMBNAIL_83fb12f7-d5b6-4067-9480-6f3ca2637246.jpg?v=1775498843	0	2026-04-21 10:23:23.002964	2026-04-16 10:29:16.976838	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
724	37	Daily Driver Kit - Thunderbird	https://ridge.com/products/daily-driver-kit-thunderbird	150	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Thunderbird-DDK-THUMBNAIL.jpg?v=1775069038	0	2026-04-21 10:23:23.003854	2026-04-16 10:29:16.976839	2026-05-15 05:09:37.010697	EDC - BLEND - DAILY DRIVER KIT - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
725	37	Daily Driver Kit - Lone Wolf	https://ridge.com/products/daily-driver-kit-lone-wolf	175	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/LoneWolf-DDK-THUMBNAIL.jpg?v=1774994042	0	2026-04-21 10:23:23.004665	2026-04-16 10:29:16.976839	2026-05-15 05:09:37.010697	EDC - BLEND - DAILY DRIVER KIT - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
726	37	Daily Driver Kit - Hot Rod	https://ridge.com/products/daily-driver-kit-hot-rod	125	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/HotRod-DDK-THUMBNAIL.jpg?v=1774632657	0	2026-04-21 10:23:23.005465	2026-04-16 10:29:16.97684	2026-05-15 05:09:37.010697	EDC - BLEND - DAILY DRIVER KIT - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
727	37	Ridge Wallet - Hot Rod	https://ridge.com/products/hot-rod	95	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/HotRod-Wallet-THUMBNAIL.jpg?v=1774631436	0	2026-04-21 10:23:23.006129	2026-04-16 10:29:16.97684	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
554	9	Silver Remarkable Set	https://giva.co/products/silver-remarkable-set	10099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02820_PD02522_1_ae5ecd27-cde0-4f14-9f54-3bb1a4ad964d.jpg?v=1743056256	0	2026-04-13 10:51:18.907415	2026-04-13 10:51:18.932601	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
557	9	Golden Aura Tangle Set	https://giva.co/products/golden-aura-tangle-set	4999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03729_ER04049_1.jpg?v=1775720619	0	2026-04-13 10:51:18.912304	2026-04-13 10:51:18.932602	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
566	9	Silver Charming Oval Set	https://giva.co/products/silver-charming-oval-set	8699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLPD0127_TLER0201_1.jpg?v=1773319701	0	2026-04-13 10:51:18.92062	2026-04-13 10:51:18.932608	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
567	9	Silver Royal Pink Gorgeous Set	https://giva.co/products/silver-cherry-prunus-set	17099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER01940_PD01820_1-min.jpg?v=1675505945	0	2026-04-13 10:51:18.921349	2026-04-13 10:51:18.932609	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
568	9	Rose Gold Rani Ebony Convertible Set	https://giva.co/products/bhumi-rose-gold-rani-ebony-convertible-set	8799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02487_PD02245_1.jpg?v=1697798132	0	2026-04-13 10:51:18.922062	2026-04-13 10:51:18.932609	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
569	9	Rose Gold Rani Ebony Pendant with Link Chain	https://giva.co/products/bhumi-rose-gold-rani-ebony-pendant-with-link-chain	4299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02245_1.jpg?v=1697725757	0	2026-04-13 10:51:18.922844	2026-04-13 10:51:18.93261	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
719	37	Wallet + Tracker Card	https://ridge.com/products/wallet-tracker-card	140	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Frame51.jpg?v=1776275847	0	2026-04-21 10:23:22.998528	2026-04-16 10:29:16.976834	2026-05-15 05:09:37.010697	hide	\N	t	t	\N	0	0	culture	shopify	backfill
730	37	Ridge Power Bank - 10k mAh Bundle - Atomic Purple - 3-Pack	https://ridge.com/products/magnetic-power-bank-bundle-3-pack-atomic-purple	159	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/MagneticPowerbank-Bundle3-AtomicPurple-THUMBNAIL1.jpg?v=1774907785	0	2026-04-21 10:23:23.008303	2026-04-16 10:29:16.976842	2026-05-15 05:09:37.010697	Tech - Power Banks - Ridge Power Bank - 10k mAh Bundle - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
731	37	Ridge Power Bank - 10k mAh Bundle - Atomic Purple - 2-Pack	https://ridge.com/products/magnetic-power-bank-bundle-2-pack-atomic-purple	139	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/MagneticPowerbank-Bundle-AtomicPurple-THUMBNAIL2.jpg?v=1774907761	0	2026-04-21 10:23:23.009079	2026-04-16 10:29:16.976843	2026-05-15 05:09:37.010697	Tech - Power Banks - Ridge Power Bank - 10k mAh Bundle - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
732	37	Ridge Power Bank - 10k mAh - Atomic Purple	https://ridge.com/products/magnetic-power-bank-atomic-purple	79	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/MagneticPowerbank-AtomicPurple-THUMBNAIL.jpg?v=1774905943	0	2026-04-21 10:23:23.009714	2026-04-16 10:29:16.976843	2026-05-15 05:09:37.010697	Tech - Power Banks - Ridge Power Bank - 10k mAh - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
733	37	Long Haul Kit - MKBHD	https://ridge.com/products/long-haul-kit-mkbhd-royal-black	445	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/LongHaul_Kit_RoyalBlack_CO_MKBHD-THUMB.jpg?v=1751583682	0	2026-04-21 10:23:23.010329	2026-04-16 10:29:16.976844	2026-05-15 05:09:37.010697	TRAVEL - LUGGAGE - LONG HAUL KIT - KIT	\N	f	f	\N	0	0	culture	shopify	backfill
734	37	Frequent Flyer Kit - MKBHD	https://ridge.com/products/frequent-flyer-kit-mkbhd	345	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Frame6_ba362f7a-1fe9-4847-845e-34ff46b2af38.jpg?v=1774476757	0	2026-04-21 10:23:23.011197	2026-04-16 10:29:16.976844	2026-05-15 05:09:37.010697	TRAVEL - LUGGAGE - FREQUENT FLYER KIT - KIT	\N	f	f	\N	0	0	culture	shopify	backfill
735	37	Members Only Kit	https://ridge.com/products/members-only-kit	69	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/SmallBulge-Wallet-THUMBNAIL.jpg?v=1774812279	0	2026-04-21 10:23:23.012063	2026-04-16 10:29:16.976845	2026-05-15 05:09:37.010697	EDC - Kits - Members Only Kit - KIT	\N	f	f	\N	0	0	culture	shopify	backfill
736	37	Mesh Snapback - Members Only	https://ridge.com/products/mesh-snapback-members-only	29	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/SmallBulge-Cap-THUMBNAIL.jpg?v=1774808505	0	2026-04-21 10:23:23.012816	2026-04-16 10:29:16.976846	2026-05-15 05:09:37.010697	EDC - APPAREL - MESH TRUCKER SNAPBACK - SINGLE	\N	f	f	\N	0	0	culture	shopify	backfill
737	37	Daily Driver Kit - NASA - Apollo Legacy	https://ridge.com/products/daily-driver-kit-nasa-apollo-legacy	125	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Frame6_3a45d9bf-463b-44cd-9284-a54849748c03.jpg?v=1773947726	0	2026-04-21 10:23:23.013497	2026-04-16 10:29:16.976846	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
747	37	Daily Driver Kit - Iridescent	https://ridge.com/products/daily-driver-kit-iridescent	125	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Iridescence-DDK-THUMBNAIL.jpg?v=1770821703	0	2026-04-16 10:38:40.889738	2026-04-16 10:29:16.976852	2026-05-15 05:09:37.010697	EDC - BLEND - DAILY DRIVER KIT - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
748	37	Daily Driver Kit - Forgedfetti	https://ridge.com/products/daily-driver-kit-forgedfetti	175	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Forgedfetti-DDK-THUMBNAIL.jpg?v=1770821555	0	2026-04-16 10:38:40.890238	2026-04-16 10:29:16.976852	2026-05-15 05:09:37.010697	EDC - BLEND - DAILY DRIVER KIT - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
869	31	Desk Shelf Pro	https://oakywood.shop/products/desk-shelf-pro	439	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/deskshelfpro-oak-single-black-03.webp?v=1762440306	0	2026-05-14 07:20:34.515539	2026-04-16 10:29:26.740177	2026-05-15 05:09:37.010697	20%	\N	t	t	\N	0	0	culture	shopify	backfill
779	36	LastTissue Barrier Upgrade	https://lastobject.com/products/lasttissues-barrier	0	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/products/lasttissue-barrier-upgrade-lastobject-496871.jpg?v=1618911317	0	2026-05-14 07:20:40.117025	2026-04-16 10:29:20.122616	2026-05-15 05:09:37.010697	for-cs	\N	t	t	\N	0	0	beauty	shopify	backfill
780	36	Baby Kit	https://lastobject.com/products/baby-kits	41	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/products/baby-kit-bundle-test-en-lastobject-687113.jpg?v=1686049158	0	2026-05-14 07:20:40.117841	2026-04-16 10:29:20.122633	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
781	36	LastTissue Refill - 18 pack	https://lastobject.com/products/lasttissue-refill-family-pack-3-refills	36	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/products/lasttissue-refill-18-pack-b2c-lastswab-405775.jpg?v=1660265372	0	2026-05-14 07:20:40.118375	2026-04-16 10:29:20.122633	2026-05-15 05:09:37.010697	B2C	\N	t	t	\N	0	0	beauty	shopify	backfill
782	36	LastSwab PRO	https://lastobject.com/products/lastswab-pro	24	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/LastSwab_Black_Trio_watermark.webp?v=1759761748	0	2026-05-14 07:20:40.118821	2026-04-16 10:29:20.122634	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
709	33	CurrentBody Skin LED Multi-Light Mask & Brightening Neck & Décolletage Mask	https://currentbody.com/products/currentbody-skin-multi-light-mask-brightening-neck-dec	729.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Multi-Light_Mask_with_Brightening_Neck_Dec.jpg?v=1775144946	0	2026-04-16 10:38:42.964462	2026-04-16 10:29:11.565071	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
1013	9	Silver Nazar Waist Chain	https://giva.co/products/silver-nazar-waist-chain	4499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/WCH01_2.jpg?v=1772433522	0	2026-04-16 10:38:49.157515	2026-04-16 10:38:49.170976	2026-05-15 05:09:37.010697	Waist Chain	\N	t	t	\N	0	0	culture	shopify	backfill
857	31	Standing Desk Pro (140x70)	https://oakywood.shop/products/standing-desk-pro-140x70-1	1402	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/walnut_8efb2abb-7b8b-4712-9a30-496c9aa12b26.jpg?v=1760969305	0	2026-05-14 07:20:34.510346	2026-04-16 10:29:26.740171	2026-05-15 05:09:37.010697	outlet	\N	t	t	\N	0	0	culture	shopify	backfill
858	31	Catchall Tray (Outlet)	https://oakywood.shop/products/catchall-tray-outlet	58	USD	https://cdn.shopify.com/s/files/1/2447/0423/products/IMG_0034.jpg?v=1762439632	0	2026-05-14 07:20:34.510955	2026-04-16 10:29:26.740172	2026-05-15 05:09:37.010697	tray	\N	t	t	\N	0	0	culture	shopify	backfill
859	31	Cubic Pot (Outlet)	https://oakywood.shop/products/cubic-pot-outlet	33	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/IMG_0028_7fbdddd7-acc6-4a4b-a0e8-98f3332332a6.jpg?v=1762439832	0	2026-05-14 07:20:34.511598	2026-04-16 10:29:26.740172	2026-05-15 05:09:37.010697	outlet	\N	t	t	\N	0	0	culture	shopify	backfill
860	31	Large Tray (OakyBlocks) (Outlet)	https://oakywood.shop/products/large-tray-oakyblocks-outlet	41	USD	https://cdn.shopify.com/s/files/1/2447/0423/products/IMG_0046_1.jpg?v=1762439781	0	2026-05-14 07:20:34.511998	2026-04-16 10:29:26.740173	2026-05-15 05:09:37.010697	OakyBlocks	\N	t	t	\N	0	0	culture	shopify	backfill
861	31	Small Tray (OakyBlocks) (Outlet)	https://oakywood.shop/products/small-tray-oakyblocks-outlet	33	USD	https://cdn.shopify.com/s/files/1/2447/0423/products/IMG_0050_3.jpg?v=1762439779	0	2026-05-14 07:20:34.512382	2026-04-16 10:29:26.740173	2026-05-15 05:09:37.010697	OakyBlocks	\N	t	t	\N	0	0	culture	shopify	backfill
715	33	ZIIP HALO Facial Toning Device	https://currentbody.com/products/zp-hidden	379	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/microcurrent-facial-device-ziip-halo.jpg?v=1737649739	0	2026-05-07 03:05:41.835803	2026-04-16 10:29:11.565075	2026-05-15 05:09:37.010697	ZIIP	\N	t	t	\N	0	0	beauty	shopify	backfill
716	33	CurrentBody Skin Series 2 Mask & Brightening Neck & Décolletage Mask (Worth £708)	https://currentbody.com/products/currentbody-skin-face-neck-brightening-kit	638.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Face_Brightening_Neck_Kit_69cc31de-e478-4fb8-8146-51fc745b8fa8.png?v=1763375478	0	2026-04-16 10:38:42.967494	2026-04-16 10:29:11.565075	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
872	31	Desk-Mounted Headphone Hook	https://oakywood.shop/products/desk-mounted-headphone-hook	54	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/headphonehook-oak-black-01.webp?v=1758552647	0	2026-05-14 07:20:34.516611	2026-04-16 10:29:26.740178	2026-05-15 05:09:37.010697	20%	\N	t	t	\N	0	0	culture	shopify	backfill
873	31	Hanging Desk Organizer	https://oakywood.shop/products/hanging-desk-organizer	219	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/hangingdeskorganizer-stonegrey-oak-black-01.jpg?v=1758552175	0	2026-05-14 07:20:34.516993	2026-04-16 10:29:26.740179	2026-05-15 05:09:37.010697	20%	\N	t	t	\N	0	0	culture	shopify	backfill
1039	31	Wooden Pen Organizer	https://oakywood.shop/products/wooden-pen-organizer	32	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/8_1800px_9c4d91b0-f2ef-4269-b536-7592ad37a89f.webp?v=1775768861	0	2026-05-14 07:20:34.504864	2026-04-21 10:23:00.727639	2026-05-15 05:09:37.010697	archive collection	\N	t	t	\N	0	0	culture	shopify	backfill
707	33	CurrentBody Skin Cryo Roller	https://currentbody.com/products/currentbody-skin-cryo-roller	30	USD	https://cdn.shopify.com/s/files/1/3097/7858/products/CB_Essentials_ecom10032_e0e280d4-1c8f-4477-a689-03c8d85838a8.jpg?v=1684487776	0	2026-05-14 07:21:16.372598	2026-04-16 10:29:11.56507	2026-05-15 05:09:37.010697	Tool	\N	t	t	\N	0	0	beauty	shopify	backfill
710	33	CurrentBody Skin LED Multilight Mask & Face Hydrogels (10 Pack)	https://currentbody.com/products/currentbody-skin-led-multilight-face-hydrogels-ten-pack	550.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/multi-light-mask-hydrogels-10-pack.png?v=1775559722	0	2026-05-14 07:21:16.387277	2026-04-16 10:29:11.565072	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
711	33	CurrentBody Skin LED Multilight Mask & Face Hydrogels (5 Pack)	https://currentbody.com/products/currentbody-skin-led-multilight-face-hydrogels-five-pack	512.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/multi-light-mask-5-pack-hydrogels.png?v=1775560050	0	2026-05-14 07:21:16.387635	2026-04-16 10:29:11.565072	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
880	31	Valet Tray	https://oakywood.shop/products/valet-tray	46	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/valettray-oak-large-01.webp?v=1758553820	0	2026-04-16 10:38:47.909474	2026-04-16 10:29:26.740182	2026-05-15 05:09:37.010697	tray	\N	t	t	\N	0	0	culture	shopify	backfill
881	31	Catchall Tray Mini Bundle	https://oakywood.shop/products/catchall-tray-mini-bundle	87	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/catchalltraymini-oak-bundle-01.jpg?v=1758619314	0	2026-04-16 10:38:47.909908	2026-04-16 10:29:26.740183	2026-05-15 05:09:37.010697	tray	\N	t	t	\N	0	0	culture	shopify	backfill
882	31	Catchall Tray Mini	https://oakywood.shop/products/catchall-tray-mini	31	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/catchalltraymini-oak-large-01.jpg?v=1758553166	0	2026-04-16 10:38:47.910288	2026-04-16 10:29:26.740183	2026-05-15 05:09:37.010697	tray	\N	t	t	\N	0	0	culture	shopify	backfill
354	5	5 Layers PM 2.5 Carbon Mask Filters For Kids Cloth Mask	https://thekarelab.com/products/5-layers-pm-2-5-carbon-mask-filters-for-kids-cloth-mask-b2c	32	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/5-layers-pm-25-carbon-mask-filters-for-kids-cloth-mask-527198.png?v=1648453569	0	2026-05-14 07:20:27.773234	2026-04-11 06:27:34.217657	2026-05-14 07:20:27.777405	Masks	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
1153	21	Lightweight Denim Easy Short | Light Indigo	https://everlane.com/products/mens-lightweight-denim-easy-short-light-indigo	98	USD	\N	0	2026-05-07 03:04:37.770615	2026-05-07 03:04:37.779355	2026-05-07 03:04:37.779355	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1154	21	Flowy Denim Midi Skirt | Rinse Indigo	https://everlane.com/products/womens-flowy-denim-midi-skirt-rinse-indigo	118	USD	\N	0	2026-05-07 03:04:37.771082	2026-05-07 03:04:37.779355	2026-05-07 03:04:37.779356	Denim	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1155	21	Open Knit Long-Sleeve Crew in Everyday Cotton | Canvas / Navy	https://everlane.com/products/womens-open-knit-ls-crew-everyday-cotton-black-canvas-true-navy-stripe	128	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/76e7d2b7_c1e7.jpg?v=1775678417	0	2026-05-07 03:04:37.771569	2026-05-07 03:04:37.779356	2026-05-07 03:04:37.779356	Sweaters	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1156	21	The Boxy Sweater in Everyday Cotton | Imperial Blue	https://everlane.com/products/womens-organic-cotton-crew-sweater-imperial-blue	108	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/39035ab1_5f34.jpg?v=1775689208	0	2026-05-07 03:04:37.772015	2026-05-07 03:04:37.779356	2026-05-07 03:04:37.779357	Sweaters	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
717	33	CurrentBody Skin LED Mask Series 2 & Sauna Blanket	https://currentbody.com/products/currentbody-skin-led-light-therapy-mask-s2-sauna-blanket	853	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Series_2_Sauna.png?v=1775145512	0	2026-05-14 07:21:16.385853	2026-04-16 10:29:11.565076	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
718	33	CurrentBody Skin LED Brightening Neck & Décolletage Mask	https://currentbody.com/products/currentbody-skin-led-brightening-neck-decolletage-mask	309.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/NECK_DECK_BRIGHTNING_MODEL1_aef2411d-5651-4301-86b5-9e758e10924d.jpg?v=1776243895	0	2026-04-16 10:38:42.96843	2026-04-16 10:29:11.565076	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
929	27	Classic Film Paper Case	https://papershoot.com/products/paper-case-classic-film-camera-copy	19.5	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera_Product1925_80eedbd9-cac7-49bc-a6e8-e719a0343c77.png?v=1764141033	0	2026-05-14 07:20:29.411461	2026-04-16 10:29:29.298438	2026-05-15 05:09:37.010697	case	\N	t	t	\N	0	0	culture	shopify	backfill
930	27	HandDrawn Paper Case	https://papershoot.com/products/handdrawn-paper-case	19.5	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera_ProductRED.png?v=1766566532	0	2026-05-14 07:20:29.411793	2026-04-16 10:29:29.298438	2026-05-15 05:09:37.010697	case	\N	t	t	\N	0	0	culture	shopify	backfill
931	27	FruitPlay Paper Case	https://papershoot.com/products/fruitplay-paper-case	23	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera_ProductStrawberry_F_bb3b13f4-d644-4fd2-95b2-66a9182d6ef7.png?v=1764142975	0	2026-05-14 07:20:29.412114	2026-04-16 10:29:29.298439	2026-05-15 05:09:37.010697	case	\N	t	t	\N	0	0	culture	shopify	backfill
932	27	Pattern Play Paper Case	https://papershoot.com/products/paper-case-autumn-bloom-copy	23	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Productautumnbloom.png?v=1764138233	0	2026-05-14 07:20:29.412421	2026-04-16 10:29:29.298439	2026-05-15 05:09:37.010697	case	\N	t	t	\N	0	0	culture	shopify	backfill
933	27	Canvas Bloom Paper Case	https://papershoot.com/products/paper-case-summer-bloom-quite-copy	19.5	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera_ProductQuiet_74286384-29c8-47ad-9505-3b572970bea0.png?v=1764137145	0	2026-05-14 07:20:29.412742	2026-04-16 10:29:29.298439	2026-05-15 05:09:37.010697	case	\N	t	t	\N	0	0	culture	shopify	backfill
874	31	Desk Setup Touch Bundle	https://oakywood.shop/products/desk-setup-touch-bundle	1762	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/desksetuptouch-oak-black-01.jpg?v=1758620520	0	2026-05-14 07:20:34.517349	2026-04-16 10:29:26.740179	2026-05-15 05:09:37.010697	all	\N	t	t	\N	0	0	culture	shopify	backfill
875	31	Desk Setup Pro Bundle	https://oakywood.shop/products/desk-setup-pro-bundle	2163	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/desksetuppro-oak-black-01.jpg?v=1758551699	0	2026-05-14 07:20:34.517705	2026-04-16 10:29:26.74018	2026-05-15 05:09:37.010697	all	\N	t	t	\N	0	0	culture	shopify	backfill
877	31	Standing Desk Pro Mini Bundle	https://oakywood.shop/products/standing-desk-pro-mini-bundle	1476	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/deskprominibundle-oak-black-04.jpg?v=1758634686	0	2026-05-14 07:20:34.51844	2026-04-16 10:29:26.740181	2026-05-15 05:09:37.010697	all	\N	t	t	\N	0	0	culture	shopify	backfill
878	31	Magnetic Cable Organizer	https://oakywood.shop/products/magnetic-cable-organizer	43	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/magneticcableorganizer-oak-black-01.webp?v=1758553002	0	2026-05-14 07:20:34.518783	2026-04-16 10:29:26.740181	2026-05-15 05:09:37.010697	30%	\N	t	t	\N	0	0	culture	shopify	backfill
1181	37	Ridge Wallet - Philadelphia Eagles - Carbon Fiber 3k	https://ridge.com/products/philadelphia-eagles-carbon-fiber-3k	119	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/WALLET_Philadelphia_Premium_Carbon-thumb_87fc169e-fb72-41a2-bf35-f72e6c5d21fd.jpg?v=1728071764	0	2026-05-14 07:21:41.352952	2026-05-07 03:04:49.51328	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
714	33	CurrentBody Skin LED Multi Light Therapy Mask	https://currentbody.com/products/currentbody-skin-led-multi-light-mask	499.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/currentbody-skin-led-multi-light-face-on.png?v=1774454386	0	2026-05-14 07:21:16.386235	2026-04-16 10:29:11.565074	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1246	33	CurrentBody Skin Anti-Blemish LED Pen	https://currentbody.com/products/currentbody-skin-blue-light-therapy-pen	59.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/anti-blemish-pen-currentbody-skin-1.jpg?v=1775814463	0	2026-05-14 07:21:16.370353	2026-05-14 07:21:16.389841	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
797	36	Facial Cleanser Refill	https://lastobject.com/products/facial-cleanser-refill	20	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Carousel_Facial_Cleanser_Refill_1.jpg?v=1710321855	0	2026-05-14 07:20:40.124507	2026-04-16 10:29:20.122642	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
798	36	Body Wash Refill	https://lastobject.com/products/body-wash-refill	18	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Body_Wash_Refill_New_LastObject_Powder_2x_all_variants.jpg?v=1763582590	0	2026-05-14 07:20:40.124871	2026-04-16 10:29:20.122643	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
799	36	Hand Wash Refill	https://lastobject.com/products/hand-wash-refill	12	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Carousel_Hand_Wash_Refill_1.jpg?v=1710322255	0	2026-05-14 07:20:40.125203	2026-04-16 10:29:20.122643	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
800	36	Laundry Detergent Sheets	https://lastobject.com/products/laundry-detergent-sheets	21	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Frame_91.jpg?v=1709047346	0	2026-05-14 07:20:40.125535	2026-04-16 10:29:20.122644	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
1248	33	CurrentBody Skin Hydrogel Eye Mask	https://currentbody.com/products/currentbody-skin-hydrogel-eye-mask	29.95	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/hydrogel_eye_mask_1.png?v=1774950987	0	2026-05-14 07:21:16.3748	2026-05-14 07:21:16.389842	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1249	33	CurrentBody Skin Hydrogel Face Mask	https://currentbody.com/products/currentbody-skin-hydrogel-face-mask	39.95	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/hydrogel_face_mask_1.png?v=1774944955	0	2026-05-14 07:21:16.375301	2026-05-14 07:21:16.389843	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1250	33	CurrentBody Skin Hydrogel Face Mask (10 Pack)	https://currentbody.com/products/currentbody-hydrogel-masks-10-pack	70	USD	https://cdn.shopify.com/s/files/1/3097/7858/products/NEW_CB_HYDROGEL_FACE_TEN_FRONT_3.jpg?v=1684487966	0	2026-05-14 07:21:16.375855	2026-05-14 07:21:16.389843	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1251	33	CurrentBody Skin Hydrogel Lip Mask	https://currentbody.com/products/currentbody-skin-hydrogel-lip-mask	29.95	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/hydrogel_lip_mask_1.png?v=1775659900	0	2026-05-14 07:21:16.376399	2026-05-14 07:21:16.389844	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1252	33	CurrentBody Skin Hydrogel Neck and Décolletage Mask	https://currentbody.com/products/currentbody-skin-hydrogel-decolletage-mask	39.95	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/hydrogel_neck_mask_1.png?v=1776243551	0	2026-05-14 07:21:16.377129	2026-05-14 07:21:16.389844	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
912	28	Temple Smoke Utility Beard Wash	https://beardbrand.com/products/temple-smoke-utility-beard-wash	36	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/UWTS_KO.jpg?v=1768597208	0	2026-04-21 10:23:29.49662	2026-04-16 10:29:28.091199	2026-05-15 05:09:37.010697	Utility Wash	\N	t	t	\N	0	0	beauty	shopify	backfill
690	33	The Skin Rewind	https://currentbody.com/products/trinny-london-the-skin-rewind	489	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/cb_skin_trinny_the_rewind.png?v=1771851289	0	2026-05-07 03:05:41.809305	2026-04-16 10:29:11.565062	2026-05-15 05:09:37.010697	PR	\N	f	f	\N	0	0	beauty	shopify	backfill
1254	33	CurrentBody Skin LED Anti-Blemish Mask: Series 2 & Pen	https://currentbody.com/products/currentbody-skin-anti-blemish-led-mask-pen	436.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/series2-_acne-currentbody-skin-led-mask-acne-logo.jpg?v=1775822320	0	2026-05-14 07:21:16.378937	2026-05-14 07:21:16.389845	2026-05-15 05:09:37.010697	Device	\N	t	t	\N	0	0	beauty	shopify	backfill
1255	33	CurrentBody Skin LED Blue Light Therapy Face Mask	https://currentbody.com/products/currentbody-skin-red-and-blue-light-therapy-mask	399.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/LED-Anti-Blemish-Mask-Series-2.png?v=1760699719	0	2026-05-14 07:21:16.37948	2026-05-14 07:21:16.389845	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1256	33	CurrentBody Skin LED Eye Mask	https://currentbody.com/products/currentbody-skin-led-eye-perfector	189.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/eye-mask-gallery-image-1.png?v=1770915997	0	2026-05-14 07:21:16.380077	2026-05-14 07:21:16.389846	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1258	33	CurrentBody Skin LED Face & Neck Kit: Series 2	https://currentbody.com/products/currentbody-skin-complete-led-kit	679.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/led_face_neck_kit_face_on_10193eb0-c7c2-4f1b-a6ed-9d22c31b4c06.png?v=1776351365	0	2026-05-14 07:21:16.381741	2026-05-14 07:21:16.389847	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1261	33	CurrentBody Skin LED Hand Mask	https://currentbody.com/products/currentbody-skin-hand-perfector	189.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/hand_perfector_new_logo.jpg?v=1773245502	0	2026-05-14 07:21:16.383598	2026-05-14 07:21:16.389848	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1208	37	Ridge Power Bank - 10k mAh Bundle - Neon Tiger - 3-Pack	https://ridge.com/products/magnetic-power-bank-bundle-3-pack-neon-tiger	159	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/MagneticPowerbank-Bundle3-AtomicPurple-THUMBNAIL1_6ad8c046-df45-4737-b523-a2adddaa3c87.jpg?v=1776816214	0	2026-05-07 03:04:49.51097	2026-05-07 03:04:49.513297	2026-05-15 05:09:37.010697	Tech - Power Banks - Ridge Power Bank - 10k mAh Bundle - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
689	33	CurrentBody Skin LED 4-in-1 Zone Facial Mapping Mask	https://currentbody.com/products/currentbody-skin-led-zone-facial-mapping-mask	449.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/4-in-1_face_mask.png?v=1775562619	0	2026-05-14 07:21:16.378421	2026-04-16 10:29:11.56506	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1262	33	CurrentBody Skin LED Lip Mask	https://currentbody.com/products/currentbody-skin-led-lip-perfector	189.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Currentbody_skin_LED_lip_device-model.png?v=1773245296	0	2026-05-14 07:21:16.385291	2026-05-14 07:21:16.389848	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
1209	37	Ridge Power Bank - 10k mAh Bundle - Neon Tiger - 2-Pack	https://ridge.com/products/magnetic-power-bank-bundle-2-pack-neon-tiger	139	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/MagneticPowerbank-Bundle-AtomicPurple-THUMBNAIL2_66943244-d5ec-4003-ad4b-3d49286a3acd.jpg?v=1776816074	0	2026-05-07 03:04:49.511483	2026-05-07 03:04:49.513297	2026-05-15 05:09:37.010697	Tech - Power Banks - Ridge Power Bank - 10k mAh Bundle - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
1007	9	Gold Solitaire Diamond Nose Pin	https://giva.co/products/gold-solitaire-diamond-nose-pin	6902.22	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDLNP051_2.jpg?v=1715172433	0	2026-04-16 10:38:49.152853	2026-04-16 10:38:49.170973	2026-05-15 05:09:37.010697	Gold Nose Pin	\N	t	t	\N	0	0	culture	shopify	backfill
173	8	Scheelite Stone	https://energymuse.com/products/scheelite-stone	9.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/ScheeliteStone.png?v=1774393344	0	2026-04-13 10:51:30.688172	2026-04-10 10:30:59.100385	2026-04-13 10:51:30.68886	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
1211	28	Norse Winter Utility Bar 3-Pack	https://beardbrand.com/products/norse-winter-utility-bar-soap-3-pack	45	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BAR_only.jpg?v=1764021473	0	2026-05-14 07:21:46.903816	2026-05-07 03:04:58.69939	2026-05-15 05:09:37.010697	Utility Bar	\N	t	t	\N	0	0	beauty	shopify	backfill
783	36	LastTissue Family Kit	https://lastobject.com/products/lasttissue-family-kit	72	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Aurora.jpg?v=1704808916	0	2026-05-14 07:20:40.119244	2026-04-16 10:29:20.122634	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
784	36	LastSwab Family Kit	https://lastobject.com/products/lastswab-family-kit	36	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/AuroraLSO_7adb4fc3-4a74-4f44-b9c8-05ca117b7951.jpg?v=1704812430	0	2026-05-14 07:20:40.119667	2026-04-16 10:29:20.122635	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
785	36	LastSwab Refill	https://lastobject.com/products/lastswab-refill	8	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/image80.png?v=1701048811	0	2026-05-14 07:20:40.120074	2026-04-16 10:29:20.122636	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
549	18	Luma iPhone Case	https://lumacases.com/products/luma-iphone-case	23.99	USD	https://cdn.shopify.com/s/files/1/0651/5625/1701/files/Your_paragraph_text_4.png?v=1764725966	0	2026-05-14 07:21:28.127481	2026-04-11 08:55:28.655799	2026-05-15 05:09:37.010697	Luma Cases	\N	t	t	\N	0	0	culture	shopify	backfill
550	18	Luma Lighter	https://lumacases.com/products/luminous-quicksand-lighter	26.99	USD	https://cdn.shopify.com/s/files/1/0651/5625/1701/files/Your_paragraph_text_3.png?v=1764726070	0	2026-05-14 07:21:28.128113	2026-04-11 08:55:28.6558	2026-05-15 05:09:37.010697	Luma Cases	\N	t	t	\N	0	0	culture	shopify	backfill
987	23	Iron	https://ritual.com/products/iron-bioseries	22	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP_Iron_Bottle.jpg?v=1770263136	0	2026-05-14 07:21:14.108779	2026-04-16 10:29:45.852245	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
988	23	Magnesium+	https://ritual.com/products/magnesium	50	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-MAG-Carousel-01.jpg?v=1770263110	0	2026-05-14 07:21:14.109128	2026-04-16 10:29:45.852246	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
990	23	Fertility Support	https://ritual.com/products/fertility-support	99	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-FS-Package-1.jpg?v=1770263112	0	2026-05-14 07:21:14.109906	2026-04-16 10:29:45.852247	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
991	23	Omega-3 DHA & EPA	https://ritual.com/products/omega-3-dha-epa	33	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-Omega-Bottle.jpg?v=1770263103	0	2026-05-14 07:21:14.110275	2026-04-16 10:29:45.852247	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
992	23	Sleep	https://ritual.com/products/sleep-bioseries-melatonin	25	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP_SLP_Bottle.jpg?v=1770263109	0	2026-05-14 07:21:14.110658	2026-04-16 10:29:45.852248	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
993	23	Stress Relief	https://ritual.com/products/stress-relief-bioseries	54	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-Stress-Bottle.jpg?v=1770263109	0	2026-05-14 07:21:14.111056	2026-04-16 10:29:45.852248	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
995	23	Natal Choline	https://ritual.com/products/natal-choline	29	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-Choline-Bottle.jpg?v=1770263104	0	2026-05-14 07:21:14.111894	2026-04-16 10:29:45.85225	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
999	23	Daily Shake	https://ritual.com/products/essential-protein-daily-shake-18	44	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-PD18-Bag_f125fdc4-6812-45b7-a56e-faf0bf89e3c2.jpg?v=1774026738	0	2026-05-14 07:21:14.113531	2026-04-16 10:29:45.852252	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
1000	23	Synbiotic+	https://ritual.com/products/synbiotic-plus-for-gut-health	54	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-SYN-Bottle.jpg?v=1770263121	0	2026-05-14 07:21:14.113924	2026-04-16 10:29:45.852252	2026-05-15 05:09:37.010697	18-49	\N	t	t	\N	0	0	health	shopify	backfill
665	29	Keychron 2-in-1 Switch and Keycap Puller	https://keychron.com/products/keychron-2-in-1-switch-and-keycap-puller	13.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-2-in-1-Switch-and-Keycap-Puller-Black-1.jpg?v=1773999991	0	2026-05-14 07:21:29.222098	2026-04-16 10:29:10.034069	2026-05-15 05:09:37.010697	Z-Others	\N	t	t	\N	0	0	culture	shopify	backfill
668	29	Keychron Silicone Palm Rest	https://keychron.com/products/keychron-silicone-palm-rest	12.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-Silicone-Palm-Rest-for-V1_V2_Q2_Q9_Q1Pro_Q2Pro.jpg?v=1703068194	0	2026-05-14 07:21:29.223231	2026-04-16 10:29:10.034071	2026-05-15 05:09:37.010697	Z-Others	\N	t	t	\N	0	0	culture	shopify	backfill
681	29	Keychron B11 Pro Ultra-Slim Wireless Foldable Keyboard	https://keychron.com/products/keychron-b11-pro-ultra-slim-wireless-foldable-keyboard	64.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-B11-Pro-Features.jpg?v=1772534835	0	2026-05-14 07:21:29.227881	2026-04-16 10:29:10.034077	2026-05-15 05:09:37.010697	Slim Keyboards	\N	t	t	\N	0	0	culture	shopify	backfill
1264	29	Keychron Q0 Mini 8K Action Key	https://keychron.com/products/keychron-q0-mini-8k-action-key	64.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-Q0-Mini-8K-Features.jpg?v=1776766050	0	2026-05-14 07:21:29.217795	2026-05-14 07:21:29.231693	2026-05-15 05:09:37.010697	Z-Others	\N	f	f	\N	0	0	culture	shopify	backfill
542	17	Van Rysel Men's EDR Cycling Shorts	https://decathlon.com/products/van-rysel-mens-edr-cycling-shorts	99.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_b113ca21-eb83-4916-a4d6-fc40e5a4df82.jpg?v=1775496567	0	2026-04-21 10:23:09.926164	2026-04-11 08:54:53.631315	2026-05-15 05:09:37.010697	Cycling bib shorts	\N	t	t	\N	0	0	sports	shopify	backfill
543	17	Van Rysel Unisex EDR ULTRA Cycling Jersey	https://decathlon.com/products/van-rysel-unisex-edr-ultra-cycling-jersey	99.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_9b77c109-1e84-4b2e-abdd-feb585529561.jpg?v=1775496552	0	2026-04-21 10:23:09.926978	2026-04-11 08:54:53.631315	2026-05-15 05:09:37.010697	Short-sleeved jersey	\N	t	t	\N	0	0	sports	shopify	backfill
546	17	Ultra Compact Swimming Microfiber towel - XL 110 x 175 cm	https://decathlon.com/products/ultra-compact-swimming-microfiber-towel-xl-110-x-175-cm-2	24.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_62c8538b-21c9-491b-91e1-1eb0438a861a.jpg?v=1775496673	0	2026-04-21 10:23:09.93165	2026-04-11 08:54:53.631317	2026-05-15 05:09:37.010697	Towel	\N	t	t	\N	0	0	sports	shopify	backfill
1182	37	Ridge Wallet - Tennessee Titans	https://ridge.com/products/tennessee-titans	99	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Wallet_Tennessee_Thumbnail.jpg?v=1715189237	0	2026-05-14 07:21:41.353676	2026-05-07 03:04:49.513281	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
1183	37	Ridge Wallet - Los Angeles Rams	https://ridge.com/products/los-angeles-rams	99	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Wallet_LARams_Thumbnail.jpg?v=1715273565	0	2026-05-14 07:21:41.354277	2026-05-07 03:04:49.513282	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
1032	9	Silver Stunner Anklet	https://giva.co/products/silver-stunner-anklet	1599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0509_2.jpg?v=1763041639	0	2026-04-16 10:38:49.168334	2026-04-16 10:38:49.170987	2026-05-15 05:09:37.010697	Anklets	\N	t	t	\N	0	0	culture	shopify	backfill
1034	9	Golden Glinting Joy Zircon Set	https://giva.co/products/golden-glinting-joy-zircon-set	11299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0454_ER0615_1.jpg?v=1639752345	0	2026-04-16 10:38:49.169342	2026-04-16 10:38:49.170989	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
697	33	CurrentBody Skin LED Light Therapy Panel	https://currentbody.com/products/currentbody-skin-led-light-therapy-full-body-panel	899.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/New_LED_panel_veritace_logo.png?v=1775833588	0	2026-05-14 07:21:16.384631	2026-04-16 10:29:11.565065	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
974	23	Day & Night Support Ritual*	https://ritual.com/products/day-night-recovery-ritual	104	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Day-_-Night-Recovery.webp?v=1773185848	0	2026-05-14 07:21:14.103271	2026-04-16 10:29:45.852239	2026-05-15 05:09:37.010697	bundle	\N	t	t	\N	0	0	health	shopify	backfill
1206	37	Ridge Wallet - Heritage	https://ridge.com/products/heritage	150	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/HeritageEdition-Wallet-THUMBNAIL.jpg?v=1776183416	0	2026-05-14 07:21:41.365005	2026-05-07 03:04:49.513296	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
1265	37	Ridge Chain Accessory - Cleaning Cloth	https://ridge.com/products/ridge-chain-accessory-cleaning-cloth	35	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Frame553.png?v=1778631382	0	2026-05-14 07:21:41.348822	2026-05-14 07:21:41.369206	2026-05-15 05:09:37.010697	EXTRA-NFS	\N	f	f	\N	0	0	culture	shopify	backfill
1266	37	Ridge Chain Accessory - Travel Case	https://ridge.com/products/ridge-chain-travel-case	35	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Screenshot2026-01-13at9.57.34AM1.jpg?v=1778629862	0	2026-05-14 07:21:41.350547	2026-05-14 07:21:41.369207	2026-05-15 05:09:37.010697	EXTRA-NFS	\N	f	f	\N	0	0	culture	shopify	backfill
871	31	Small modular drawer (Outlet)	https://oakywood.shop/products/small-modular-drawer-outlet	91	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/smallmodulardrawer-oak-single-black-szare-01.jpg?v=1762440035	0	2026-05-14 07:20:34.516253	2026-04-16 10:29:26.740178	2026-05-15 05:09:37.010697	outlet	\N	t	t	\N	0	0	culture	shopify	backfill
879	31	Stackable Valet Trays Bundle	https://oakywood.shop/products/valet-tray-bundle	122	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/valettray-oak-bundle-01.webp?v=1758617721	0	2026-05-14 07:20:34.519116	2026-04-16 10:29:26.740182	2026-05-15 05:09:37.010697	all	\N	t	t	\N	0	0	culture	shopify	backfill
691	33	The Ultimate Elevator	https://currentbody.com/products/trinny-london-the-ultimate-elevator	385	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/cbskin_trinny_london_the_elevator_bundle.png?v=1771851347	0	2026-05-07 03:05:41.812813	2026-04-16 10:29:11.565062	2026-05-15 05:09:37.010697	PR	\N	f	f	\N	0	0	beauty	shopify	backfill
692	33	CurrentBody Skin Version 1 USB Charging Controller	https://currentbody.com/products/currentbody-skin-version-2-charger	29.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/CopyofCB07-NBeC-power_1.jpg?v=1763028586	0	2026-05-07 03:05:41.815169	2026-04-16 10:29:11.565063	2026-05-15 05:09:37.010697	LED	\N	t	t	\N	0	0	beauty	shopify	backfill
694	33	CurrentBody Skin LED Therapy Panel & Sauna Blanket	https://currentbody.com/products/currentbody-skin-led-therapy-panel-sauna-blanket	1304.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/led-light-therapy-panel-and-sauna-kit.png?v=1775833588	0	2026-05-07 03:05:41.818687	2026-04-16 10:29:11.565064	2026-05-15 05:09:37.010697	Device	\N	t	t	\N	0	0	beauty	shopify	backfill
695	33	Sonia Selaire x CurrentBody LED Face & Neck Kit	https://currentbody.com/products/sonia-selaire-x-currentbody-face-and-neck-kit	679.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/sonia-led-light-therapy-mask-currentbody-skin_81fc310a-fe92-4fdd-8729-190c0c22c76f.png?v=1762506074	0	2026-05-07 03:05:41.81968	2026-04-16 10:29:11.565064	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	f	2026-05-07 03:05:41.81968	0	0	beauty	shopify	backfill
698	33	CurrentBody Skin LED Illuminated Mirror	https://currentbody.com/products/currentbody-skin-led-illuminated-mirror	59.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/currentbody-skin-mirror.jpg?v=1769768708	0	2026-05-14 07:21:16.384176	2026-04-16 10:29:11.565066	2026-05-15 05:09:37.010697	LED	\N	f	f	\N	0	0	beauty	shopify	backfill
699	33	CurrentBody Skin LED Multi-Light Mask & Infrared Sauna Blanket	https://currentbody.com/products/currentbody-skin-multi-light-mask-sauna-blanket	944.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Multi-Light_and_Sauna_Blanket_Bundle.png?v=1775567771	0	2026-05-14 07:21:16.386925	2026-04-16 10:29:11.565066	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
701	33	CurrentBody Skin Multi-Light Mask Special Kit	https://currentbody.com/products/currentbody-skin-multi-light-mask-special-kit	555.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/currentbody-skin-led-multi-light-mask-special-kit_f508ab92-5cfd-43e9-b31a-605859afb7fd.png?v=1766403925	0	2026-05-07 03:05:41.825465	2026-04-16 10:29:11.565067	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
1157	21	Weekend Tee Mini Dress | True Navy / Canvas Tan	https://everlane.com/products/womens-weekend-tee-mini-dress-true-navy-canvas-tan	78	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/979468bc_3d83.jpg?v=1775689208	0	2026-05-07 03:04:37.772487	2026-05-07 03:04:37.779357	2026-05-07 03:04:37.779357	Dresses	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
704	33	CurrentBody Skin LED Therapy Panel & Sauna Blanket - Black Friday Exclusive	https://currentbody.com/products/currentbody-skin-led-therapy-panel-sauna-blanket-pr-offer	1304.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/led-light-therapy-panel-and-sauna-kit.png?v=1775833588	0	2026-05-07 03:05:41.828251	2026-04-16 10:29:11.565069	2026-05-15 05:09:37.010697	PR	\N	t	t	\N	0	0	beauty	shopify	backfill
708	33	Currentbody Skin Multilight Mask & Anti-Blemish Pen	https://currentbody.com/products/currentbody-skin-multi-light-mask-anti-blemish-pen	530.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/CB_MultiLight_BlemishPen.jpg?v=1775560673	0	2026-05-07 03:05:41.830835	2026-04-16 10:29:11.565071	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
1158	21	Lightweight Terry Blouson Crew | Pale Peach	https://everlane.com/products/womens-lightweight-terry-blouson-crew-pale-peach	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/dad1d9b5_b2d6.jpg?v=1775685610	0	2026-05-07 03:04:37.772975	2026-05-07 03:04:37.779357	2026-05-07 03:04:37.779358	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1159	21	Weekend Track Pant | Bone	https://everlane.com/products/womens-weekend-track-pant-bone	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/413655d7_2d3f.jpg?v=1775689207	0	2026-05-07 03:04:37.773412	2026-05-07 03:04:37.779358	2026-05-07 03:04:37.779358	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
712	33	CurrentBody Skin RF Microneedling Treatment - Exclsuive Offer	https://currentbody.com/products/currentbody-skin-radiofrequency-microneedling-treatment-offer	339.48	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Radio_Frequency_RF_Device_Microneedling_Starter_Kit.jpg?v=1763376925	0	2026-05-07 03:05:41.833612	2026-04-16 10:29:11.565073	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
1216	33	CurrentBody Skin Under Eye Microneedling Patches	https://currentbody.com/products/currentbody-skin-under-eye-microneedling-patches	59.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/MICRONEEDLING_EYES_MODEL2.jpg?v=1767878068	0	2026-05-07 03:05:41.839505	2026-05-07 03:05:41.845683	2026-05-15 05:09:37.010697	Radiofrequency	\N	t	t	\N	0	0	beauty	shopify	backfill
801	36	Facial Cleanser	https://lastobject.com/products/facial-cleanser	25	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Carousel_Facial_Cleanser_Bottle_1_0ed3a5de-16d5-45f7-b952-ae6982cd95e1.jpg?v=1708601521	0	2026-05-14 07:20:40.12587	2026-04-16 10:29:20.122644	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
802	36	Body Wash	https://lastobject.com/products/body-wash	23	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Carousel_Body_Wash_Bottle_1_b1cd847a-5ff1-47f1-94d5-ec67b41d54f6.jpg?v=1708601503	0	2026-05-14 07:20:40.126225	2026-04-16 10:29:20.122645	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
803	36	Hand Wash	https://lastobject.com/products/hand-wash	17	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/products/Carousel_Hand_Wash_Bottle_1.jpg?v=1708355111	0	2026-05-14 07:20:40.126576	2026-04-16 10:29:20.122645	2026-05-15 05:09:37.010697	Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
805	36	Tote Bag	https://lastobject.com/products/tote-bag	19	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/1_Hero.png?v=1696515984	0	2026-05-14 07:20:40.127216	2026-04-16 10:29:20.122646	2026-05-15 05:09:37.010697	New	\N	f	f	\N	0	0	beauty	shopify	backfill
937	27	Aura Bricks Case	https://papershoot.com/products/aura-bricks-case	49.9	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/PapershootcameraAURAbricksBlueBeam_9d64e43c-fe2e-4e2a-9f86-5a830a9796cb.png?v=1764163239	0	2026-05-14 07:20:29.413887	2026-04-16 10:29:29.298441	2026-05-15 05:09:37.010697	aura bricks	\N	t	t	\N	0	0	culture	shopify	backfill
938	27	Aura Palette Case	https://papershoot.com/products/aura-palette-case	49.9	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Lavender_Lemonade_691b6c16-5929-49bf-97c1-8865e630f825.png?v=1764151725	0	2026-05-14 07:20:29.414188	2026-04-16 10:29:29.298441	2026-05-15 05:09:37.010697	Aura Case	\N	t	t	\N	0	0	culture	shopify	backfill
939	27	Aura Paper Case	https://papershoot.com/products/aura-paper-amber-roll-case	35	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/PaperShootCameraAurapaperAmberRoll_12eba7e1-715a-407e-961c-40a237e398ac.jpg?v=1766566507	0	2026-05-14 07:20:29.414487	2026-04-16 10:29:29.298442	2026-05-15 05:09:37.010697	Aura Case	\N	t	t	\N	0	0	culture	shopify	backfill
1160	21	Tissue Short-Sleeve Crew | Blue Dusk	https://everlane.com/products/womens-everlight-short-sleeve-crew-blue-dusk	58	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/48df6bcb_5bc2.jpg?v=1775689206	0	2026-05-07 03:04:37.773824	2026-05-07 03:04:37.779358	2026-05-07 03:04:37.779358	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
632	21	Pointed-Toe Slingback Heel | Black Leather	https://everlane.com/products/womens-pointed-toe-slingback-heel-black	228	USD	\N	0	2026-04-16 10:38:40.035535	2026-04-16 10:29:07.01461	2026-04-16 10:38:40.048704	Flats + Other	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
301	9	Silver Kinda Cube Stud For Him	https://giva.co/products/silver-kinda-cube-stud-for-him	1699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER0107_1.png?v=1758206117	0	2026-04-11 06:24:31.631602	2026-04-11 06:24:31.657999	2026-04-11 06:24:31.658	Men's Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
302	9	Golden Kate Necklace	https://giva.co/products/golden-kate-necklace	10399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02921_1.jpg?v=1748524469	0	2026-04-11 06:24:31.633264	2026-04-11 06:24:31.658001	2026-04-11 06:24:31.658001	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
303	9	Silver Moo Kids Studs	https://giva.co/products/silver-moo-kids-studs	2599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/KER030_1.jpg?v=1750346233	0	2026-04-11 06:24:31.634777	2026-04-11 06:24:31.658001	2026-04-11 06:24:31.658002	Kids Earring	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
304	9	Silver Mesmerising Vanki Ring	https://giva.co/products/silver-mesmerising-vanki-ring	2799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01569_1.jpg?v=1701955206	0	2026-04-11 06:24:31.636493	2026-04-11 06:24:31.658002	2026-04-11 06:24:31.658003	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
305	9	Silver Florence Cuff Bracelet	https://giva.co/products/silver-florence-cuff-bracelet	13899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01570_1.jpg?v=1770904034	0	2026-04-11 06:24:31.638018	2026-04-11 06:24:31.658003	2026-04-11 06:24:31.658003	Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1038	33	CurrentBody Skin Forehead Microneedling Patch	https://currentbody.com/products/currentbody-skin-forehead-microneedling-patch	59.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/MICRONEEDLING_FORHEAD_MODEL2_f4a7b1db-69f2-4879-8fa7-c1e593fc6579.jpg?v=1762527906	0	2026-05-14 07:21:16.37343	2026-04-21 10:23:00.14861	2026-05-15 05:09:37.010697	Radiofrequency	\N	t	t	\N	0	0	beauty	shopify	backfill
1089	25	Dishwasher Detergent Tablet Refills	https://blueland.com/products/dishwasher-refill-packs	21	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Dish_Free_Clear_Refill_Final_2026_01.jpg?v=1769803449	0	2026-05-14 07:20:29.693354	2026-04-21 11:26:58.611649	2026-05-14 07:20:29.705079	Refills	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1161	21	Tissue Layered Tank | Aleutian/Velvet Morning	https://everlane.com/products/womens-tissue-layered-tank-aleutian-velvet-morning	58	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/13f24df8_e925.jpg?v=1775689206	0	2026-05-07 03:04:37.774255	2026-05-07 03:04:37.779359	2026-05-07 03:04:37.779359	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1162	21	Scoopneck Cami | White	https://everlane.com/products/womens-scoopneck-cami-white	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/108a32e5_b28e.jpg?v=1775689206	0	2026-05-07 03:04:37.774665	2026-05-07 03:04:37.779359	2026-05-07 03:04:37.779359	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1163	21	Scoop-Neck Midi Dress in Pointelle Knit | Heathered Chocolate Chip	https://everlane.com/products/womens-scoop-neck-midi-dress-pointelle-heathered-chocolate-chip	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/aa7f0520_7fb7.jpg?v=1775689205	0	2026-05-07 03:04:37.77508	2026-05-07 03:04:37.77936	2026-05-07 03:04:37.77936	Dresses	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
1041	31	A4 Document Holder	https://oakywood.shop/products/a4-document-holder	87	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/2_1800px_12142841-86d1-4a3f-8a7c-563eb3ed89eb.webp?v=1775764797	0	2026-05-14 07:20:34.507171	2026-04-21 10:23:00.727641	2026-05-15 05:09:37.010697	archive collection	\N	t	t	\N	0	0	culture	shopify	backfill
1210	28	Norse Winter Utility Deodorant	https://beardbrand.com/products/norse-winter-aluminum-free-deodorant	27	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/UDNW.jpg?v=1777311325	0	2026-05-14 07:21:46.902103	2026-05-07 03:04:58.699389	2026-05-15 05:09:37.010697	Deodorant	\N	t	t	\N	0	0	beauty	shopify	backfill
807	36	LastTissue Refill	https://lastobject.com/products/lasttissue-refill	12	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/1_Hero_30fc1076-741e-439d-936f-10041c32bcca.png?v=1705042350	0	2026-05-14 07:20:40.127891	2026-04-16 10:29:20.122648	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
604	34	Arivea Lilies Red Light Mat - Black	https://linnerlife.com/products/arivea-lilies-red-light-mat-black	169.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Arivea_Red_Light_Mat.png?v=1774423984	0	2026-05-14 07:21:55.803539	2026-04-16 10:29:04.554701	2026-05-15 05:09:37.010697	Linner	\N	f	f	\N	0	0	culture	shopify	backfill
605	34	Arivea Hibiscus Pro Red Light Face Mask- Blue	https://linnerlife.com/products/arivea-hibiscus-pro-red-light-face-mask-blue	299.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Arivea_Hibiscus_Pro_Face_Mask.png?v=1774424079	0	2026-05-14 07:21:55.804498	2026-04-16 10:29:04.554702	2026-05-15 05:09:37.010697	Linner	\N	f	f	\N	0	0	culture	shopify	backfill
1164	21	RetroSoft Cotton One-Shoulder Tank | Mayfly	https://everlane.com/products/womens-retrosoft-cotton-oneshoulder-tank-mayfly	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/2fe72642_429e.jpg?v=1775689205	0	2026-05-07 03:04:37.77549	2026-05-07 03:04:37.779362	2026-05-07 03:04:37.779362	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
606	34	Arivea Morigold Red Light Panel - Black	https://linnerlife.com/products/arivea-morigold-red-light-panel-black	249.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/1_4e6389f4-70eb-4c6b-96e8-bef383b99a83.jpg?v=1775643029	0	2026-05-14 07:21:55.80519	2026-04-16 10:29:04.554702	2026-05-15 05:09:37.010697	Linner	\N	f	f	\N	0	0	culture	shopify	backfill
1165	21	Racerback Tank in Pointelle | Skywriting	https://everlane.com/products/womens-racerback-tank-in-pointelle-skywriting	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/74a60159_fd65.jpg?v=1775685609	0	2026-05-07 03:04:37.775885	2026-05-07 03:04:37.779362	2026-05-07 03:04:37.779362	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
608	34	Arivea - Wireless Red Light Therapy Mask for Face, Rechargeable NIR LED, Home & Travel	https://linnerlife.com/products/arivea-hibiscus-red-light-therapy-face-mask	169.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/1774503715401.png?v=1774504850	0	2026-05-14 07:21:55.806396	2026-04-16 10:29:04.554703	2026-05-15 05:09:37.010697	Linner	\N	t	t	\N	0	0	culture	shopify	backfill
609	34	Meraw Blood Pressure Monitors	https://linnerlife.com/products/meraw-blood-pressure-monitors	56.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Mearw-Cedar-Bluetooth-Blood-Preesure-Monitor-Linner-110422412.webp?v=1774432941	0	2026-05-14 07:21:55.806971	2026-04-16 10:29:04.554704	2026-05-15 05:09:37.010697	Linner	\N	t	t	\N	0	0	culture	shopify	backfill
613	34	Meraw Oak Blood Preesure Monitor	https://linnerlife.com/products/meraw-oak-blood-preesure-monitor	49.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Meraw-Oak-Bluetooth-Blood-Pressure-Monitor-Linner-110421777.webp?v=1727259077	0	2026-05-14 07:21:55.809125	2026-04-16 10:29:04.554706	2026-05-15 05:09:37.010697	Meraw	\N	t	t	\N	0	0	culture	shopify	backfill
614	34	Meraw Aspen Blood Preesure Monitor-white	https://linnerlife.com/products/meraw-aspen-blood-preesure-monitor-white	49.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Meraw-Aspen-Bluetooth-Wrist-Blood-Pressure-Monitor-Linner-110421078.webp?v=1727258137	0	2026-05-14 07:21:55.809655	2026-04-16 10:29:04.554706	2026-05-15 05:09:37.010697	Meraw	\N	t	t	\N	0	0	culture	shopify	backfill
615	34	Meraw Cedar Blood Pressure Monitor-Black	https://linnerlife.com/products/meraw-cedar-blood-pressure-monitor-black	56.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Mearw-Cedar-Bluetooth-Blood-Preesure-Monitor-Linner-110422412.webp?v=1774432941	0	2026-05-14 07:21:55.810211	2026-04-16 10:29:04.554707	2026-05-15 05:09:37.010697	Linner	\N	t	t	\N	0	0	culture	shopify	backfill
616	34	Meraw Cuff(fit with Cedar, Oak)	https://linnerlife.com/products/meraw-cufffit-with-cedar-oak	19.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/3fc5623e-417a-4c68-9448-c8461662d25e.a5f260813460fb11f3f1c09f06c5b340.jpg?v=1745023551	0	2026-05-14 07:21:55.810688	2026-04-16 10:29:04.554707	2026-05-15 05:09:37.010697	Linner	\N	t	t	\N	0	0	culture	shopify	backfill
618	34	Mearw Cedar Bluetooth Blood Preesure Monitor	https://linnerlife.com/products/mearw-cedar-bluetooth-blood-preesure-monitor	56.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Mearw-Cedar-Bluetooth-Blood-Preesure-Monitor-Linner-110419927.webp?v=1727257644	0	2026-05-14 07:21:55.811566	2026-04-16 10:29:04.554708	2026-05-15 05:09:37.010697	Linner	\N	t	t	\N	0	0	culture	shopify	backfill
619	34	Linner charging case	https://linnerlife.com/products/linner-charging-case	29	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Linner-charging-case-Linner-1690406732761_29a5ca4d-750c-4411-b575-275ee4179042.jpg?v=1691640620	0	2026-05-14 07:21:55.811966	2026-04-16 10:29:04.554708	2026-05-15 05:09:37.010697	Linner charging case	\N	t	t	\N	0	0	culture	shopify	backfill
621	34	Saturn Wax Guard(8pcs)	https://linnerlife.com/products/saturn-wax-guard	14.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Saturn_Wax_Guard.webp?v=1774424254	0	2026-05-14 07:21:55.812849	2026-04-16 10:29:04.554709	2026-05-15 05:09:37.010697	Ear Wax Protection	\N	t	t	\N	0	0	culture	shopify	backfill
622	34	Domes	https://linnerlife.com/products/domes	19.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/LINNER-Mercury-Eartips-Linner-109797959.jpg?v=1725360681	0	2026-05-14 07:21:55.813223	2026-04-16 10:29:04.55471	2026-05-15 05:09:37.010697	Comfortable Ear Tips	\N	t	t	\N	0	0	culture	shopify	backfill
623	34	LINNER Mercury Wax Guard(8pcs)	https://linnerlife.com/products/linner-mercury-wax-guard	14.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/LINNER-Mercury-Wax-Guard-Linner-109797863.png?v=1725360678	0	2026-05-14 07:21:55.813655	2026-04-16 10:29:04.55471	2026-05-15 05:09:37.010697	Earwax Protection	\N	t	t	\N	0	0	culture	shopify	backfill
624	34	Price Difference	https://linnerlife.com/products/price-difference	1	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Price-Difference-Linner-109794997.png?v=1725360654	0	2026-05-14 07:21:55.814084	2026-04-16 10:29:04.554711	2026-05-15 05:09:37.010697	Consumer Rights	\N	t	t	\N	0	0	culture	shopify	backfill
519	17	Quechua 2 Second Fresh & Black Waterproof Pop Up Camping Tent 2 Person	https://decathlon.com/products/quechua-2-second-fresh-black-waterproof-pop-up-camping-tent-2-person	149	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_6bf56f1e-86d0-4c15-a53a-65d05776dfc7.jpg?v=1775484521	0	2026-04-21 10:23:09.895563	2026-04-11 08:54:53.6313	2026-05-15 05:09:37.010697	Tent	\N	t	t	\N	0	0	sports	shopify	backfill
520	17	Quechua 2 Second Fresh & Black Waterproof Pop Up Camping Tent 3 Person	https://decathlon.com/products/quechua-2-second-fresh-black-waterproof-pop-up-camping-tent-3-person	179	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_61b7c2b5-6153-47b1-9fdd-f7b1bc7ec944.jpg?v=1775484437	0	2026-04-21 10:23:09.89779	2026-04-11 08:54:53.631301	2026-05-15 05:09:37.010697	Tent	\N	t	t	\N	0	0	sports	shopify	backfill
521	17	Quechua 2 Second Easy Fresh & Black Waterproof Pop Up Camping Tent - 2 Person	https://decathlon.com/products/quechua-2-second-easy-fresh-black-waterproof-pop-up-camping-tent-2-person	259	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_2c6f0e6b-734d-4199-a0d1-4a7eb9c97d70.jpg?v=1775483774	0	2026-04-21 10:23:09.899538	2026-04-11 08:54:53.631302	2026-05-15 05:09:37.010697	Tent	\N	t	t	\N	0	0	sports	shopify	backfill
523	17	Van Rysel RCR-F PRO DURA ACE DI2	https://decathlon.com/products/van-rysel-rcr-f-pro-dura-ace-di2	11599	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_5a91c13f-9016-4884-81fa-4319405fcb3c.jpg?v=1775490860	0	2026-04-21 10:23:09.903101	2026-04-11 08:54:53.631303	2026-05-15 05:09:37.010697	Road bike	\N	t	t	\N	0	0	sports	shopify	backfill
524	17	Arpenaz 4.1 Fresh & Black Camping Tent - 4-person	https://decathlon.com/products/arpenaz-4-1-fresh-black-camping-tent-4-person	329	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_991b64bf-c5ce-4d4d-8453-3387a4003480.jpg?v=1775484939	0	2026-04-21 10:23:09.904509	2026-04-11 08:54:53.631303	2026-05-15 05:09:37.010697	Tent	\N	t	t	\N	0	0	sports	shopify	backfill
525	17	2 SECONDS EASY Fresh and Black - 3 Person	https://decathlon.com/products/2-seconds-easy-fresh-and-black-3-person	359	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_117e0451-7b9a-4238-b9a3-ed08834f046a.jpg?v=1775484901	0	2026-04-21 10:23:09.905993	2026-04-11 08:54:53.631304	2026-05-15 05:09:37.010697	Tent	\N	t	t	\N	0	0	sports	shopify	backfill
526	17	Microfiber Swimming Towel Size XL 110 x 175 cm	https://decathlon.com/products/microfiber-swimming-towel-size-xl-110-x-175-cm	24.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_8e6d7be6-5c01-448a-a519-ad5795dd3b62.jpg?v=1775494049	0	2026-04-21 10:23:09.907359	2026-04-11 08:54:53.631305	2026-05-15 05:09:37.010697	Towel	\N	t	t	\N	0	0	sports	shopify	backfill
306	9	Silver Ganapathi & Lakshmi Idol	https://giva.co/products/silver-ganapathi-lakshmi-idol	6399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ID044_5.jpg?v=1727960777	0	2026-04-11 06:24:31.639351	2026-04-11 06:24:31.658004	2026-05-15 05:09:37.010697	idol	\N	t	\N	\N	0	0	culture	shopify	backfill
527	17	Van Rysel XCR TRIATHLON ULTEGRA DI2	https://decathlon.com/products/van-rysel-xcr-triathlon-ultegra-di2	8499	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_2b2f6fb1-86fa-4f0b-b3ab-57a43be1de4c.jpg?v=1775491210	0	2026-04-21 10:23:09.908636	2026-04-11 08:54:53.631305	2026-05-15 05:09:37.010697	Road bike	\N	t	t	\N	0	0	sports	shopify	backfill
528	17	Van Rysel EDR AF CLARIS	https://decathlon.com/products/van-rysel-edr-af-claris	1199	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_cad5e3c9-3822-4e0d-95ca-5765e960a405.jpg?v=1775491122	0	2026-04-21 10:23:09.909788	2026-04-11 08:54:53.631306	2026-05-15 05:09:37.010697	Road bike	\N	t	t	\N	0	0	sports	shopify	backfill
529	17	Quechua Comfort Camping Pillow	https://decathlon.com/products/quechua-comfort-camping-pillow	19.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_1e1ab4f3-06c2-4702-a3b9-913f0b49b50b.jpg?v=1775490984	0	2026-04-21 10:23:09.91111	2026-04-11 08:54:53.631307	2026-05-15 05:09:37.010697	Pillow	\N	t	t	\N	0	0	sports	shopify	backfill
531	17	Van Rysel 2026 RCR-R Decathlon CMA CGM Replica Team Jersey	https://decathlon.com/products/van-rysel-2026-rcr-r-decathlon-cma-cgm-replica-team-jersey	99.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_f9b03b22-5fb6-4d54-b6d1-0c3fd927ce84.jpg?v=1775494122	0	2026-04-21 10:23:09.913805	2026-04-11 08:54:53.631308	2026-05-15 05:09:37.010697	Short-sleeved jersey	\N	t	t	\N	0	0	sports	shopify	backfill
533	17	Van Rysel Men's RCR-R 5 Road Cycling Shorts	https://decathlon.com/products/van-rysel-mens-rcr-r-5-road-cycling-shorts	119	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_720450d7-cb0b-4813-8c9a-8a5a3030460f.jpg?v=1775494080	0	2026-04-21 10:23:09.916221	2026-04-11 08:54:53.631309	2026-05-15 05:09:37.010697	Cycling bib shorts	\N	t	t	\N	0	0	sports	shopify	backfill
534	17	Quechua MH100 Kids’ 5L Hiking Backpack	https://decathlon.com/products/quechua-mh100-kids-5l-hiking-backpack	19.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_c81d8af1-1fc9-4af3-b332-c136eb8c72ec.jpg?v=1775495678	0	2026-04-21 10:23:09.917479	2026-04-11 08:54:53.63131	2026-05-15 05:09:37.010697	Backpack	\N	t	t	\N	0	0	sports	shopify	backfill
535	17	2 pocket Waterproof BumBag	https://decathlon.com/products/2-pocket-waterproof-bumbag	29.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_0d7fb7f8-f7a6-4c4d-8b84-b3e66c14e190.jpg?v=1775495660	0	2026-04-21 10:23:09.918455	2026-04-11 08:54:53.63131	2026-05-15 05:09:37.010697	Belt bag	\N	t	t	\N	0	0	sports	shopify	backfill
536	17	Quechua Ultimate Comfort Self-Inflating Mattress - 2 Person	https://decathlon.com/products/quechua-ultimate-comfort-self-inflating-mattress-2-person	249	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_cd3688cc-d73b-46a9-b04c-52c34e906899.jpg?v=1775495643	0	2026-04-21 10:23:09.919578	2026-04-11 08:54:53.631311	2026-05-15 05:09:37.010697	Mattress	\N	t	t	\N	0	0	sports	shopify	backfill
537	17	Quechua Ultimate Comfort Self-Inflating Camping Mattress	https://decathlon.com/products/quechua-ultimate-comfort-self-inflating-camping-mattress	159	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_cbc8f44d-bf8b-4545-8e85-fe4c453b71f9.jpg?v=1775494163	0	2026-04-21 10:23:09.920533	2026-04-11 08:54:53.631312	2026-05-15 05:09:37.010697	Mattress	\N	t	t	\N	0	0	sports	shopify	backfill
1048	9	Silver Love in Circles Set	https://giva.co/products/silver-love-in-circles-set	17199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02318_ER02570_1.jpg?v=1704546920	0	2026-04-21 10:23:10.95113	2026-04-21 10:23:10.984804	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
1051	9	Silver Shadowed Brilliance Anklet	https://giva.co/products/silver-shadowed-brilliance-anklet	499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0522_2.jpg?v=1763041716	0	2026-04-21 10:23:10.954968	2026-04-21 10:23:10.984806	2026-05-15 05:09:37.010697	Anklets	\N	t	t	\N	0	0	culture	shopify	backfill
1059	9	Silver Ganesh Coin( 1g )	https://giva.co/products/silver-ganesh-coin-1g	399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/freepik_ultrarealistic-premium-pr_2798974618.png?v=1776409480	0	2026-04-21 10:23:10.965113	2026-04-21 10:23:10.98482	2026-05-15 05:09:37.010697	Coin	\N	t	t	\N	0	0	culture	shopify	backfill
1064	9	Elegance On The Rise Set	https://giva.co/products/elegance-on-the-rise-set	6399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0478_ER0627_1.jpg?v=1640959898	0	2026-04-21 10:23:10.969869	2026-04-21 10:23:10.984821	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
1065	9	Silver True Love Set of 3	https://giva.co/products/silver-true-love-set-of-3	13699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03207_ER03454_R03628_5.jpg?v=1772449635	0	2026-04-21 10:23:10.970962	2026-04-21 10:23:10.984822	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
1066	9	Silver True Love Set	https://giva.co/products/silver-true-love-set	9199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03207_ER03454_5.jpg?v=1772449656	0	2026-04-21 10:23:10.971938	2026-04-21 10:23:10.984822	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
1068	9	Oxidised Silver Star Pendant With Box Chain For Him	https://giva.co/products/oxidised-silver-star-pendant-with-box-chain-for-him	5199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02996_1.jpg?v=1753363883	0	2026-04-21 10:23:10.974014	2026-04-21 10:23:10.984823	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
1071	9	Rose Gold Drizzle Drop Pendant With Link Chain	https://giva.co/products/rose-gold-drizzle-drop-pendant-with-link-chain	3799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02257_1.jpg?v=1698336598	0	2026-04-21 10:23:10.978621	2026-04-21 10:23:10.984824	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
1072	9	Rose Gold Drizzle Drop Set	https://giva.co/products/rose-gold-drizzle-drop-set	6999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02257_22.jpg?v=1765040221	0	2026-04-21 10:23:10.979597	2026-04-21 10:23:10.984825	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
627	34	Linner Connect	https://linnerlife.com/products/linner-connect	99.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Linner-Connect-linnerlife-45314294.jpg?v=1725360535	0	2026-05-14 07:21:55.815226	2026-04-16 10:29:04.554712	2026-05-15 05:09:37.010697	Linner Connect	\N	t	t	\N	0	0	culture	shopify	backfill
1166	21	RetroSoft Cotton One-Shoulder Tank | Aleutian	https://everlane.com/products/womens-retrosoft-cotton-oneshoulder-tank-aleutian	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/12908ba7_abfb.jpg?v=1775689203	0	2026-05-07 03:04:37.776285	2026-05-07 03:04:37.779363	2026-05-07 03:04:37.779363	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1167	21	Racerback Tank in Pointelle | Heathered Chocolate Chip	https://everlane.com/products/womens-racerback-tank-in-pointelle-heathered-chocolate-chip	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/bee87eb4_0079.jpg?v=1775685608	0	2026-05-07 03:04:37.776685	2026-05-07 03:04:37.779363	2026-05-07 03:04:37.779363	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
804	36	LastRound Refill	https://lastobject.com/products/lastround-refill	9	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/image96_4232bae5-ddd2-4740-a15f-2d286807aacb.png?v=1707910762	0	2026-05-14 07:20:40.126891	2026-04-16 10:29:20.122646	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
39	5	Antiviral, Antimicrobial Silver Push Door Plate	https://www.thekarelab.com/products/antiviral-antimicrobial-silver-push-door-plate	99	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/AclivPushPlate01.png?v=1681897895	0	2026-04-10 10:15:47.650438	2026-04-10 07:18:40.627951	2026-04-10 10:15:47.650439	Infection Prevention	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
40	5	Antiviral, antimicrobial Surface Adhesive Protection Film 60MIC Clear & Matt	https://www.thekarelab.com/products/antivirus-surface-adhesive-protection-film-60mic-clear-matt	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/antivirus-surface-adhesive-protection-film-60mic-clear-matt-822269.png?v=1663940631	0	2026-04-10 10:15:47.650938	2026-04-10 07:18:40.627952	2026-04-10 10:15:47.650939	Infection Prevention	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
41	5	Antiviral, antimicrobial Tesla Navigation Screen + Door Handle Protector	https://www.thekarelab.com/products/anti-virus-tesla-navigation-screen-door-handle-protector	520	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-tesla-navigation-screen-door-handle-protector-226964.png?v=1656197114	0	2026-04-10 10:15:47.651401	2026-04-10 07:18:40.627952	2026-04-10 10:15:47.651402	Vehicles	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
42	5	Antiviral, antimicrobial Tesla Door Handle Protector Gloss	https://www.thekarelab.com/products/anti-virus-tesla-door-handle-protector-gloss-matt-b2c	180	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-tesla-door-handle-protector-gloss-matt-253828.png?v=1663335002	0	2026-04-10 10:15:47.651897	2026-04-10 07:18:40.627953	2026-04-10 10:15:47.651898	Motor Vehicles	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
43	5	Antiviral, antimicrobial Tesla Navigation Screen Protector Anti-Glare	https://www.thekarelab.com/products/anti-virus-tesla-navigation-screen-protector-anti-glare-b2c	480	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-tesla-navigation-screen-protector-anti-glare-479020.png?v=1657538161	0	2026-04-10 10:15:47.652373	2026-04-10 07:18:40.627953	2026-04-10 10:15:47.652374	Screen Protectors	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
44	5	Antiviral, antimicrobial iPad Screen Protector Clear/ Anti-Glare	https://www.thekarelab.com/products/anti-virus-ipad-pro-screen-protector-12-9-clear-b2c	480	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-ipad-screen-protector-clear-anti-glare-726340.png?v=1657635569	0	2026-04-10 10:15:47.652868	2026-04-10 07:18:40.627954	2026-04-10 10:15:47.652869	Screen Protectors	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
628	34	Linner Pictor Visual Ear Cleaner	https://linnerlife.com/products/linner-pictor-visual-ear-cleaner	79.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/LINNER-Pictor-Visual-Ear-Cleaner-Linner-43827765.jpg?v=1700711964	0	2026-05-14 07:21:55.815596	2026-04-16 10:29:04.554713	2026-05-15 05:09:37.010697	cleaner	\N	t	t	\N	0	0	culture	shopify	backfill
702	33	CurrentBody Skin Multi-Light Mask & Series 2 Neck & Dec Kit	https://currentbody.com/products/currentbody-skin-multi-light-mask-s2-neck-dec-kit	774.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/currentbody-skin-multi-light-mask-and-series-2-N_D_2c4b6fe9-857e-4642-a276-20a6e15acd13.png?v=1769783919	0	2026-05-07 03:05:41.826411	2026-04-16 10:29:11.565068	2026-05-15 05:09:37.010697	Affiliate Bundle	\N	t	t	\N	0	0	beauty	shopify	backfill
883	28	Black Sails Men's Cologne	https://beardbrand.com/products/black-sails-mens-cologne	50	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/EDP_BS_KO.jpg?v=1774456078	0	2026-05-14 07:21:46.904474	2026-04-16 10:29:28.091184	2026-05-15 05:09:37.010697	Eau de Parfum	\N	t	t	\N	0	0	beauty	shopify	backfill
884	28	Ghost Tracer Men's Cologne	https://beardbrand.com/products/ghost-tracer-mens-cologne	50	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/EDP_GT_KO.jpg?v=1774456090	0	2026-05-14 07:21:46.905005	2026-04-16 10:29:28.091186	2026-05-15 05:09:37.010697	Eau de Parfum	\N	t	t	\N	0	0	beauty	shopify	backfill
885	28	Desert Road Men's Cologne	https://beardbrand.com/products/desert-road-mens-cologne	45	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/EDP_DR_KO.jpg?v=1774456101	0	2026-05-14 07:21:46.90551	2026-04-16 10:29:28.091187	2026-05-15 05:09:37.010697	Eau de Parfum	\N	t	t	\N	0	0	beauty	shopify	backfill
886	28	Four Vices Men's Cologne	https://beardbrand.com/products/four-vices-mens-cologne	50	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/EDP_FV_KO.jpg?v=1774456060	0	2026-05-14 07:21:46.906077	2026-04-16 10:29:28.091187	2026-05-15 05:09:37.010697	Eau de Parfum	\N	t	t	\N	0	0	beauty	shopify	backfill
888	28	Temple Smoke Utility Deodorant	https://beardbrand.com/products/temple-smoke-aluminum-free-deodorant	24	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/UDTS.jpg?v=1769124316	0	2026-05-14 07:21:46.906871	2026-04-16 10:29:28.091188	2026-05-15 05:09:37.010697	Deodorant	\N	t	t	\N	0	0	beauty	shopify	backfill
889	28	Tree Ranger Utility Deodorant	https://beardbrand.com/products/tree-ranger-aluminum-free-deodorant	24	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/UDTR.jpg?v=1769124059	0	2026-05-14 07:21:46.907194	2026-04-16 10:29:28.091189	2026-05-15 05:09:37.010697	Deodorant	\N	t	t	\N	0	0	beauty	shopify	backfill
890	28	Old Money Utility Deodorant	https://beardbrand.com/products/old-money-aluminum-free-deodorant	24	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/UDOM.jpg?v=1769123487	0	2026-05-14 07:21:46.907506	2026-04-16 10:29:28.091189	2026-05-15 05:09:37.010697	Deodorant	\N	t	t	\N	0	0	beauty	shopify	backfill
891	28	Bold Fortune Utility Deodorant	https://beardbrand.com/products/bold-fortune-aluminum-free-deodorant	27	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/UDBF.jpg?v=1762468027	0	2026-05-14 07:21:46.907846	2026-04-16 10:29:28.09119	2026-05-15 05:09:37.010697	Deodorant	\N	t	t	\N	0	0	beauty	shopify	backfill
892	28	Temple Smoke Mustache Wax	https://beardbrand.com/products/temple-smoke-mustache-wax	12	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/MWTS_KO.jpg?v=1769121881	0	2026-05-14 07:21:46.90814	2026-04-16 10:29:28.09119	2026-05-15 05:09:37.010697	Mustache Wax	\N	t	t	\N	0	0	beauty	shopify	backfill
893	28	Tree Ranger Mustache Wax	https://beardbrand.com/products/tree-ranger-mustache-wax	12	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/MWTR_KO.jpg?v=1769121298	0	2026-05-14 07:21:46.908544	2026-04-16 10:29:28.09119	2026-05-15 05:09:37.010697	Mustache Wax	\N	t	t	\N	0	0	beauty	shopify	backfill
894	28	Old Money Mustache Wax	https://beardbrand.com/products/old-money-mustache-wax	12	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/MWOM.jpg?v=1762457586	0	2026-05-14 07:21:46.908906	2026-04-16 10:29:28.091191	2026-05-15 05:09:37.010697	Mustache Wax	\N	t	t	\N	0	0	beauty	shopify	backfill
895	28	Temple Smoke Beard Balm	https://beardbrand.com/products/temple-smoke-beard-balm	36	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BBTS.jpg?v=1769119492	0	2026-05-14 07:21:46.909246	2026-04-16 10:29:28.091191	2026-05-15 05:09:37.010697	Utility Balm	\N	t	t	\N	0	0	beauty	shopify	backfill
896	28	Tree Ranger Beard Balm	https://beardbrand.com/products/tree-ranger-beard-balm	36	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BBTR.jpg?v=1769118217	0	2026-05-14 07:21:46.909602	2026-04-16 10:29:28.091192	2026-05-15 05:09:37.010697	Utility Balm	\N	t	t	\N	0	0	beauty	shopify	backfill
897	28	Old Money Beard Balm	https://beardbrand.com/products/old-money-beard-balm	36	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BBOM.jpg?v=1769119016	0	2026-05-14 07:21:46.909931	2026-04-16 10:29:28.091192	2026-05-15 05:09:37.010697	Utility Balm	\N	t	t	\N	0	0	beauty	shopify	backfill
739	37	Ridge Power Bank - 10k mAh	https://ridge.com/products/bundler	79	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/MagneticPowerbank-Black-THUMBNAIL.jpg?v=1747158347	0	2026-04-21 10:23:23.014988	2026-04-16 10:29:16.976847	2026-05-15 05:09:37.010697	Tech - Power Banks - Ridge Power Bank - 10k mAh - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
745	37	Daily Survival Kit - Iridescent	https://ridge.com/products/daily-survival-kit-iridescent	195	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Iridescent-DSK-THUMBNAIL.jpg?v=1770988413	0	2026-04-21 10:23:23.018793	2026-04-16 10:29:16.976851	2026-05-15 05:09:37.010697	EDC - KNIVES - DAILY SURVIVAL KIT - KIT	\N	t	t	\N	0	0	culture	shopify	backfill
746	37	Everyday Folder - Iridescent	https://ridge.com/products/everyday-folder-iridescent	150	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Iridescent-EverydayFolder-THUMBNAIL.jpg?v=1770988167	0	2026-04-21 10:23:23.019294	2026-04-16 10:29:16.976851	2026-05-15 05:09:37.010697	EDC - KNIVES - EVERYDAY FOLDER - Single	\N	t	t	\N	0	0	culture	shopify	backfill
48	5	FFP2 NR Face Mask x 30	https://www.thekarelab.com/products/ffp2-nr-face-mask-x-30-b2c	248	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/ffp2-nr-face-mask-x-30-374261.png?v=1648929453	0	2026-04-10 10:15:47.654853	2026-04-10 07:18:40.627956	2026-04-10 10:15:47.654854	Medical Masks	\N	f	f	\N	0	0	health	shopify	m004|keyword_ma|80
50	5	3 PLY Surgical Face Masks	https://www.thekarelab.com/products/3-ply-surgical-face-mask-b2c	32	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/3-ply-surgical-face-masks-292095.png?v=1648453570	0	2026-04-10 10:15:47.655751	2026-04-10 07:18:40.627957	2026-04-10 10:15:47.655752	Medical Masks	\N	f	f	\N	0	0	health	shopify	m004|keyword_ma|80
51	5	Isolator Gown Level 1	https://www.thekarelab.com/products/isolator-gown-level-1-b2c	120	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/isolator-gown-level-1-170839.png?v=1648453572	0	2026-04-10 10:15:47.656199	2026-04-10 07:18:40.627957	2026-04-10 10:15:47.6562	Work Safety Protective Gear	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
52	5	75% Alcohol Wipe Pads	https://www.thekarelab.com/products/75-alcohol-wipe-pads-b2c	56	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/75-alcohol-wipe-pads-487935.png?v=1648453571	0	2026-04-10 10:15:47.656624	2026-04-10 07:18:40.627958	2026-04-10 10:15:47.656625	Health & Beauty	\N	f	f	\N	0	0	beauty	shopify	m004|keyword_ma|80
53	5	5 Layers PM 2.5 Carbon Mask Filters For Adult Cloth Mask	https://www.thekarelab.com/products/5-layers-pm-2-5-carbon-mask-filters-for-adult-cloth-mask-b2c	32	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/5-layers-pm-25-carbon-mask-filters-for-adult-cloth-mask-194807.png?v=1648453571	0	2026-04-10 10:15:47.657104	2026-04-10 07:18:40.627958	2026-04-10 10:15:47.657105	Masks	\N	f	f	\N	0	0	adult-products	shopify	m004|keyword_ma|80
1075	37	Personalization Charge	https://ridge.com/products/personalization-charge-uv-icon	20	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/PersonalizeIcon_FinalAsset.jpg?v=1747928385	0	2026-04-21 10:23:22.995448	2026-04-21 10:23:23.024228	2026-05-15 05:09:37.010697	PERSONALIZATION CHARGE	\N	t	t	\N	0	0	culture	shopify	backfill
1076	37	Personalization Charge	https://ridge.com/products/personalization-charge-uv-text	15	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/PersonalizeIcon_FinalAsset.jpg?v=1747928385	0	2026-04-21 10:23:22.997101	2026-04-21 10:23:23.02423	2026-05-15 05:09:37.010697	PERSONALIZATION CHARGE	\N	t	t	\N	0	0	culture	shopify	backfill
898	28	Bold Fortune Beard Balm	https://beardbrand.com/products/bold-fortune-beard-balm	39	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BBBF.jpg?v=1769118313	0	2026-05-14 07:21:46.910231	2026-04-16 10:29:28.091193	2026-05-15 05:09:37.010697	Utility Balm	\N	t	t	\N	0	0	beauty	shopify	backfill
899	28	Norse Winter Beard Balm	https://beardbrand.com/products/norse-winter-beard-balm	39	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BBNW.jpg?v=1764080489	0	2026-05-14 07:21:46.910522	2026-04-16 10:29:28.091193	2026-05-15 05:09:37.010697	Utility Balm	\N	t	t	\N	0	0	beauty	shopify	backfill
900	28	Temple Smoke Utility Bar 3-Pack	https://beardbrand.com/products/temple-smoke-utility-bar-soap-3-pack	42	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BAR_only.jpg?v=1764021473	0	2026-05-14 07:21:46.910829	2026-04-16 10:29:28.091193	2026-05-15 05:09:37.010697	Utility Bar	\N	t	t	\N	0	0	beauty	shopify	backfill
901	28	Tree Ranger Utility Bar 3-Pack	https://beardbrand.com/products/tree-ranger-utility-bar-soap-3-pack	42	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BAR_only.jpg?v=1764021473	0	2026-05-14 07:21:46.911188	2026-04-16 10:29:28.091194	2026-05-15 05:09:37.010697	Utility Bar	\N	t	t	\N	0	0	beauty	shopify	backfill
902	28	Old Money Utility Bar 3-Pack	https://beardbrand.com/products/old-money-utility-bar-soap-3-pack	42	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BAR_only.jpg?v=1764021473	0	2026-05-14 07:21:46.911599	2026-04-16 10:29:28.091194	2026-05-15 05:09:37.010697	Utility Bar	\N	t	t	\N	0	0	beauty	shopify	backfill
903	28	Bold Fortune Utility Bar 3-Pack	https://beardbrand.com/products/bold-fortune-utility-bar-soap-3-pack	45	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/BAR_only.jpg?v=1764021473	0	2026-05-14 07:21:46.91194	2026-04-16 10:29:28.091195	2026-05-15 05:09:37.010697	Utility Bar	\N	t	t	\N	0	0	beauty	shopify	backfill
904	28	Temple Smoke Sea Salt Spray	https://beardbrand.com/products/temple-smoke-sea-salt-spray	19	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/SSTS_KO.jpg?v=1769027222	0	2026-05-14 07:21:46.912288	2026-04-16 10:29:28.091195	2026-05-15 05:09:37.010697	Sea Salt Spray	\N	t	t	\N	0	0	beauty	shopify	backfill
905	28	Tree Ranger Sea Salt Spray	https://beardbrand.com/products/tree-ranger-sea-salt-spray	19	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/SSTR_KO.jpg?v=1769025745	0	2026-05-14 07:21:46.91265	2026-04-16 10:29:28.091196	2026-05-15 05:09:37.010697	Sea Salt Spray	\N	t	t	\N	0	0	beauty	shopify	backfill
906	28	Old Money Sea Salt Spray	https://beardbrand.com/products/old-money-sea-salt-spray	19	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/sss_om_42dd1a70-a424-4ffb-adba-30a87f487ef6.jpg?v=1769024220	0	2026-05-14 07:21:46.913034	2026-04-16 10:29:28.091196	2026-05-15 05:09:37.010697	Sea Salt Spray	\N	t	t	\N	0	0	beauty	shopify	backfill
907	28	Bold Fortune Sea Salt Spray	https://beardbrand.com/products/bold-fortune-sea-salt-spray	22	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/sss_bf.jpg?v=1762457593	0	2026-05-14 07:21:46.913383	2026-04-16 10:29:28.091197	2026-05-15 05:09:37.010697	Sea Salt Spray	\N	t	t	\N	0	0	beauty	shopify	backfill
908	28	Temple Smoke Utility Beard Softener	https://beardbrand.com/products/temple-smoke-utility-beard-softener	36	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/USTS_KO.jpg?v=1769020059	0	2026-05-14 07:21:46.913712	2026-04-16 10:29:28.091197	2026-05-15 05:09:37.010697	Utility Softener	\N	t	t	\N	0	0	beauty	shopify	backfill
909	28	Tree Ranger Utility Beard Softener	https://beardbrand.com/products/tree-ranger-utility-beard-softener	36	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/USTR_KO.jpg?v=1769019137	0	2026-05-14 07:21:46.914045	2026-04-16 10:29:28.091197	2026-05-15 05:09:37.010697	Utility Softener	\N	t	t	\N	0	0	beauty	shopify	backfill
910	28	Old Money Utility Beard Softener	https://beardbrand.com/products/old-money-utility-beard-softener	36	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/us_om.jpg?v=1769018084	0	2026-05-14 07:21:46.914421	2026-04-16 10:29:28.091198	2026-05-15 05:09:37.010697	Utility Softener	\N	t	t	\N	0	0	beauty	shopify	backfill
308	9	Silver Infinity Black Thread Anklets	https://giva.co/products/infinity-black-thread-anklets	1399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A093_2_dfcf31ca-c41c-43ae-b318-91d312c38277.jpg?v=1740374591	0	2026-04-11 06:24:31.641242	2026-04-11 06:24:31.658005	2026-05-15 05:09:37.010697	Anklets	\N	t	\N	\N	0	0	culture	shopify	backfill
311	9	Golden Kivar Mangalsutra	https://giva.co/products/the-kivar-mangalsutra	4299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD01360_1.jpg?v=1665072387	0	2026-04-11 06:24:31.643833	2026-04-11 06:24:31.658007	2026-05-15 05:09:37.010697	Mangalsutra	\N	t	\N	\N	0	0	culture	shopify	backfill
312	9	Golden Full of Promise Mangalsutra	https://giva.co/products/golden-full-of-promise-mangalsutra	3899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02364_1.jpg?v=1708606762	0	2026-04-11 06:24:31.644563	2026-04-11 06:24:31.658007	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
313	9	Rose Gold Cute Swirl Pendant With Link Chain	https://giva.co/products/rose-gold-cute-swirl-pendant-with-link-chain	2899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02944_1_52114f80-b8ed-479b-bd4e-c3bdd3417897.jpg?v=1756393636	0	2026-04-11 06:24:31.645262	2026-04-11 06:24:31.658008	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
54	5	5 Layers PM 2.5 Carbon Mask Filters For Kids Cloth Mask	https://www.thekarelab.com/products/5-layers-pm-2-5-carbon-mask-filters-for-kids-cloth-mask-b2c	32	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/5-layers-pm-25-carbon-mask-filters-for-kids-cloth-mask-527198.png?v=1648453569	0	2026-04-10 10:15:47.657589	2026-04-10 07:18:40.627959	2026-04-10 10:15:47.65759	Masks	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
55	5	Adult Cloth Face Mask	https://www.thekarelab.com/products/adult-cloth-mask-b2c	95	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/adult-cloth-face-mask-671939.png?v=1648323785	0	2026-04-10 10:15:47.658064	2026-04-10 07:18:40.627959	2026-04-10 10:15:47.658065	Masks	\N	f	f	\N	0	0	adult-products	shopify	m004|keyword_ma|80
60	5	Oxygen Concentrator 5L & 10L	https://www.thekarelab.com/products/oxygen-concentrator	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/oxygen-concentrator-5l-10l-258420.png?v=1626693287	0	2026-04-10 10:15:47.66049	2026-04-10 07:18:40.627961	2026-04-10 10:15:47.660491	Oxygen Tanks	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
1168	21	Cardigan in Pointelle | Skywriting	https://everlane.com/products/womens-cardigan-in-pointelle-skywriting	68	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/7ee4b148_5ae1.jpg?v=1775685607	0	2026-05-07 03:04:37.777126	2026-05-07 03:04:37.779364	2026-05-07 03:04:37.779364	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
309	9	Golden Mini Charm Necklace	https://giva.co/products/golden-mini-charm-necklace	3499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD0383_1.jpg?v=1697120049	0	2026-04-11 06:24:31.642138	2026-04-11 06:24:31.658006	2026-04-11 06:24:31.658006	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
911	28	Bold Fortune Utility Beard Softener	https://beardbrand.com/products/bold-fortune-utility-beard-softener	39	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/us_bf.jpg?v=1768598469	0	2026-04-21 10:23:29.495768	2026-04-16 10:29:28.091198	2026-05-15 05:09:37.010697	Utility Softener	\N	f	f	\N	0	0	beauty	shopify	backfill
310	9	Silver Eloquent Bow Necklace	https://giva.co/products/silver-eloquent-bow-necklace	3799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02707_1_4e315ec0-8512-413a-a6d3-d7f21c2c381a.jpg?v=1746610572	0	2026-04-11 06:24:31.64308	2026-04-11 06:24:31.658006	2026-04-11 06:24:31.658006	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
314	9	Silver Lune Layered Necklace	https://giva.co/products/silver-lune-layered-necklace	4399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02349_1.jpg?v=1708609355	0	2026-04-11 06:24:31.645923	2026-04-11 06:24:31.658009	2026-04-11 06:24:31.658009	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1169	21	Forever Jersey Cropped Tee | Aleutian	https://everlane.com/products/womens-premium-cotton-cropped-tee-aleutian	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/ca4bf680_9e8c.jpg?v=1775685608	0	2026-05-07 03:04:37.777534	2026-05-07 03:04:37.779364	2026-05-07 03:04:37.779364	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1078	29	Keychron G5 Ultra Light Wireless Mouse	https://keychron.com/products/keychron-g5-ultra-light-wireless-mouse	109.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-G5-Wireless-Mouse-feature.jpg?v=1776252465	0	2026-05-14 07:21:29.218344	2026-04-21 10:23:40.022067	2026-05-15 05:09:37.010697	Mice	\N	t	t	\N	0	0	culture	shopify	backfill
1079	29	Keychron G4 Wireless Mouse	https://keychron.com/products/keychron-g4-wireless-mouse	79.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-G4-Wireless-Mouse-Features_2.jpg?v=1776248742	0	2026-05-14 07:21:29.218866	2026-04-21 10:23:40.022089	2026-05-15 05:09:37.010697	Mice	\N	t	t	\N	0	0	culture	shopify	backfill
669	29	Keychron K3 Ultra 8K Wireless Custom Mechanical Keyboard	https://keychron.com/products/keychron-k3-ultra-8k-wireless-custom-mechanical-keyboard	109.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-K3-Ultra-8K-Wireless-Custom-MechanicalKeyboard-1.jpg?v=1774260926	0	2026-05-14 07:21:29.223596	2026-04-16 10:29:10.034071	2026-05-14 07:21:29.229551	Slim Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
134	7	Atlas Bowl | Brass	https://coreyashford.com/products/atlas-bowl-brass	450	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey_ashford_brass_atlas_bowl_catchall.jpg?v=1737509649	0	2026-04-21 10:23:11.204603	2026-04-10 10:19:59.560142	2026-04-21 10:23:11.215681	Bowl	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
511	16	Stanley 1913 x Juventus Stay-Chill Stacking Pint	https://stanley1913.com/products/stanley-1913-x-juventus-stay-chill-stacking-pint	30	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheStay-ChillStackingPint16OZ-JuventusCoded-Front.png?v=1773257113	0	2026-04-21 10:23:17.589259	2026-04-11 08:53:26.444773	2026-04-21 10:23:17.594225	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
56	5	N95 Harley Commodity	https://www.thekarelab.com/products/harley-n95-masks-harley-commodity-particulate-respirator	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/n95-harley-commodity-650764.png?v=1613322469	0	2026-04-10 10:15:47.658534	2026-04-10 07:18:40.62796	2026-04-10 10:15:47.658535	Medical Masks	\N	f	f	\N	0	0	health	shopify	m004|keyword_ma|80
57	5	N95 particulate respirators	https://www.thekarelab.com/products/n95-particulate-respirator	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/n95-particulate-respirators-343764.png?v=1613322475	0	2026-04-10 10:15:47.659077	2026-04-10 07:18:40.62796	2026-04-10 10:15:47.659078	Medical Masks	\N	f	f	\N	0	0	health	shopify	m004|keyword_ma|80
58	5	Travel Essential Protect Kit	https://www.thekarelab.com/products/travel-essential-protect-kit	250	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/travel-essential-protect-kit-379848.png?v=1651438576	0	2026-04-10 10:15:47.659533	2026-04-10 07:18:40.62796	2026-04-10 10:15:47.659534	Health Care	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
552	9	Silver Light It Up Set of 3	https://giva.co/products/silver-light-it-up-set-of-3	17599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03158_BR01427_R03384_5.jpg?v=1767594460	0	2026-04-14 03:05:45.992317	2026-04-13 10:51:18.932599	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
556	9	Silver Zircon Swan Pendant with Link Chain	https://giva.co/products/silver-zircon-swan-pendant-with-link-chain	3599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD0251_1.jpg?v=1715683125	0	2026-04-14 03:05:45.993085	2026-04-13 10:51:18.932602	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
59	5	3M - model 1860	https://www.thekarelab.com/products/3m-n95-masks-model-1860	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/3m-model-1860-204321.png?v=1613322468	0	2026-04-10 10:15:47.659971	2026-04-10 07:18:40.627961	2026-04-10 10:15:47.659972	Medical Masks	\N	f	f	\N	0	0	health	shopify	m004|keyword_ma|80
551	9	Silver Duoheart Bracelet	https://giva.co/products/silver-duoheart-bracelet	2799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01147_1.jpg?v=1736429396	0	2026-04-14 03:05:45.97861	2026-04-13 10:51:18.932598	2026-04-14 03:05:45.999335	Bracelet	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
559	9	Silver Ombre Line Tennis Bracelet	https://giva.co/products/silver-ombre-line-tennis-bracelet	4599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLBR095_1.jpg?v=1766061047	0	2026-04-14 03:05:45.994038	2026-04-13 10:51:18.932604	2026-04-14 03:05:45.999336	Trende Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
561	9	Silver Lancaster Crest Set	https://giva.co/products/silver-lancaster-crest-set	18999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03388_ER03750_5.jpg?v=1772446736	0	2026-04-14 03:05:45.996019	2026-04-13 10:51:18.932605	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
214	9	Silver Colourful Butterfly Pendant with Link Chain	https://www.giva.co/products/silver-colourful-butterfly-pendant-with-link-chain	4699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02572_1.jpg?v=1747309446	0	2026-04-11 05:22:02.712694	2026-04-11 05:22:02.730964	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
215	9	Golden Princess Set	https://www.giva.co/products/golden-princess-set	7199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02499_PD02254_5_e37c47d8-5d52-4a22-a09f-b82e0c0d4457.jpg?v=1765039491	0	2026-04-11 05:22:02.713353	2026-04-11 05:22:02.730964	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
216	9	Golden Princess Pendant With Link Chain	https://www.giva.co/products/golden-princess-pendant-with-link-chain	4099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02254_1.jpg?v=1696080167	0	2026-04-11 05:22:02.714124	2026-04-11 05:22:02.730965	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
217	9	Rose Gold Celestial Swirl Set	https://www.giva.co/products/rose-gold-celestial-love-set	6899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0816_ER0583.jpg?v=1678201116	0	2026-04-11 05:22:02.714661	2026-04-11 05:22:02.730965	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
219	9	Silver Shiny Triangle Pendant With Link Chain	https://www.giva.co/products/silver-shiny-triangle-pendant-with-link-chain	3199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02544_1.jpg?v=1738852357	0	2026-04-11 05:22:02.715956	2026-04-11 05:22:02.730966	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
560	9	Rose Gold Crimson Heart Necklace	https://giva.co/products/rose-gold-crimson-heart-necklace	3899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0227_1.jpg?v=1672895652	0	2026-04-14 03:05:45.994993	2026-04-13 10:51:18.932604	2026-04-14 03:05:45.999336	Pendant	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
211	9	Silver Purple Heartie Kids Pendants With Link Chain	https://www.giva.co/products/silver-heartie-kids-pendants-with-link-chain-1	2799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/KPD014_1.jpg?v=1750689568	0	2026-04-11 05:22:02.709913	2026-04-11 05:22:02.730961	2026-04-11 05:22:02.730962	Kids Pendant	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
212	9	Rose Gold Circular Drop Filigree Earrings	https://www.giva.co/products/rose-gold-circular-drop-filigree-earrings	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02869_1.jpg?v=1747309732	0	2026-04-11 05:22:02.711042	2026-04-11 05:22:02.730963	2026-04-11 05:22:02.730963	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
213	9	Rose Gold Heart Kids Anklet  (1-5 years)	https://www.giva.co/products/rose-gold-heart-kids-anklet	899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0439_2_6af8341d-20e0-4d15-938a-5df249562a18.jpg?v=1743166520	0	2026-04-11 05:22:02.711967	2026-04-11 05:22:02.730963	2026-04-11 05:22:02.730964	Anklets	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
218	9	Rose Gold Celestial Love Necklace	https://www.giva.co/products/star-pendant	4499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0816_1.jpg?v=1656584522	0	2026-04-11 05:22:02.715216	2026-04-11 05:22:02.730966	2026-04-11 05:22:02.730966	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
221	9	Silver Blue Butterfly Infinity Anklet	https://www.giva.co/products/silver-blue-butterfly-infinity-anklet	4299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0410_2.jpg?v=1737955521	0	2026-04-11 05:22:02.717104	2026-04-11 05:22:02.730967	2026-05-15 05:09:37.010697	Anklets	\N	t	\N	\N	0	0	culture	shopify	backfill
220	9	Silver Interlocked Heart Duo Bracelet	https://www.giva.co/products/silver-interlocked-heart-duo-bracelet	5399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR061_1.jpg?v=1713438660	0	2026-04-11 05:22:02.71642	2026-04-11 05:22:02.730967	2026-04-11 05:22:02.730967	Bracelet	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
222	9	Golden Constellation Drop Necklace	https://www.giva.co/products/golden-constellation-drop-necklace	2999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0381_1.jpg?v=1631893421	0	2026-04-11 05:22:02.717741	2026-04-11 05:22:02.730979	2026-04-11 05:22:02.73098	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
223	9	Silver Aarvik Kada For Him	https://www.giva.co/products/silver-aarvik-kada-for-him-1	9099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLBR055_1.jpg?v=1765459632	0	2026-04-11 05:22:02.718412	2026-04-11 05:22:02.73098	2026-04-11 05:22:02.73098	Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
225	9	Rose Gold Sweet Reverie Set	https://www.giva.co/products/rose-gold-sweet-reverie-set	9599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03205_ER03452_1.jpg?v=1769258879	0	2026-04-11 05:22:02.719731	2026-04-11 05:22:02.730981	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
973	23	Serena's Lineup	https://ritual.com/products/serenas-lineup	191	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Magnesium_EFW_SYN_HYA.webp?v=1773686764	0	2026-05-14 07:21:14.102629	2026-04-16 10:29:45.852238	2026-05-15 05:09:37.010697	bundle	\N	t	t	\N	0	0	health	shopify	backfill
224	9	Golden Apex Stud Earrings	https://www.giva.co/products/golden-apex-stud-earrings	899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03390_1.jpg?v=1764854755	0	2026-04-11 05:22:02.71905	2026-04-11 05:22:02.73098	2026-04-11 05:22:02.730981	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
226	9	Silver Eva Necklace	https://www.giva.co/products/silver-eva-necklace	12699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02900_1.jpg?v=1749030172	0	2026-04-11 05:22:02.720331	2026-04-11 05:22:02.730981	2026-04-11 05:22:02.730981	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
227	9	Rose Gold Lovely Bird Earrings	https://www.giva.co/products/rose-gold-lovely-bird-earrings	3699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02636_1.jpg?v=1716990944	0	2026-04-11 05:22:02.720907	2026-04-11 05:22:02.730982	2026-04-11 05:22:02.730982	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1090	25	Tablet Trio	https://blueland.com/products/tablet-trio-surprise-b	58	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Tablet_Trio_Scented_Final_2026_01.jpg?v=1769809616	0	2026-05-14 07:20:29.694024	2026-04-21 11:26:58.61165	2026-05-14 07:20:29.70508	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1097	25	Dish Soap Starter Set (Bundle)	https://blueland.com/products/dish-soap-starter-set-bab	18	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Powder_Dish_Final_2026_01.jpg?v=1769800783	0	2026-05-14 07:20:29.698307	2026-04-21 11:26:58.611653	2026-05-14 07:20:29.705081	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1098	25	Bathroom Cleaner Starter Set (Bundle)	https://blueland.com/products/bathroom-cleaner-starter-set-bab	16	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/paidsearch_bathroom_bottleandrefillandtablet_offwhite_eucalyptusmint.jpg?v=1776721155	0	2026-05-14 07:20:29.698824	2026-04-21 11:26:58.611653	2026-05-14 07:20:29.705081	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1099	25	Slate Hand Soap Starter Set (Bundle)	https://blueland.com/products/hand-soap-starter-set-bab	18	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_HS_Single__Slate_ClassicVariety_Final_2026_01.jpg?v=1769811545	0	2026-05-14 07:20:29.699392	2026-04-21 11:26:58.611653	2026-05-14 07:20:29.705081	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1100	25	Toilet Bowl Cleaner Starter Set (Bundle)	https://blueland.com/products/toilet-bowl-cleaner-starter-set-bab	23	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Toilet_Lemon_Cedar_Starter_Set_Final_2026_01.jpg?v=1769801583	0	2026-05-14 07:20:29.700008	2026-04-21 11:26:58.611654	2026-05-14 07:20:29.705082	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1101	25	Glass + Mirror Cleaner Starter Set (Bundle)	https://blueland.com/products/glass-mirror-cleaner-starter-set-bab	16	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_G_M_Spray_Final_2026_01.jpg?v=1769808877	0	2026-05-14 07:20:29.700606	2026-04-21 11:26:58.611654	2026-05-14 07:20:29.705082	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
921	27	Filter Card -Softday	https://papershoot.com/products/filter-card-softday	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/softday.png?v=1766570318	0	2026-05-14 07:20:29.408571	2026-04-16 10:29:29.298434	2026-05-14 07:20:29.415628	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1102	25	1 Year of Dish Soap	https://blueland.com/products/1-year-of-dish-soap	48	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/PLP_DTC_AnnualBundles_DishPowder_Finals_2026.jpg?v=1771441242	0	2026-05-14 07:20:29.701215	2026-04-21 11:26:58.611655	2026-05-14 07:20:29.705082	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1217	25	Variety Sample Pack	https://blueland.com/products/test-variety-sample-pack	10	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/SamplePack_Dish_LZ_Laundry_SB_Toilet_PE.png?v=1776380633	0	2026-05-14 07:20:29.683866	2026-05-14 07:20:29.70855	2026-05-14 07:20:29.70855	Samples	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
174	8	Cinnabar Stone	https://energymuse.com/products/cinnabar-stone	14.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/CinnabarStone.png?v=1774393213	0	2026-04-10 10:30:59.09529	2026-04-10 10:30:59.100385	2026-04-10 10:30:59.100385	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
175	8	Variscite Stone	https://energymuse.com/products/variscite-stone	12.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/VarisciteStone.png?v=1774392991	0	2026-04-10 10:30:59.09603	2026-04-10 10:30:59.100386	2026-04-10 10:30:59.100386	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
176	8	Mexican Turquoise Stone	https://energymuse.com/products/mexican-turquoise-stone	24.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/MexicanTurquoiseStone.png?v=1774392812	0	2026-04-10 10:30:59.096781	2026-04-10 10:30:59.100386	2026-04-10 10:30:59.100386	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
177	8	Bumble Bee Jasper Touchstone	https://energymuse.com/products/bumblebee-jasper-touchstone	18.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/bumblebee_jasper_touchstone_energymuse.png?v=1722201798	0	2026-04-10 10:30:59.097468	2026-04-10 10:30:59.100387	2026-04-10 10:30:59.100387	Crystals	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
178	8	Aquamarine Specimen	https://energymuse.com/products/aquamarine-specimen-1	68.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/AquamarineSpecimen_cba408f9-ff71-4e86-98e0-4581b33d67d0.png?v=1774030681	0	2026-04-10 10:30:59.098329	2026-04-10 10:30:59.100387	2026-04-10 10:30:59.100387	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
45	5	Antiviral, antimicrobial iPhone Screen Protector Clear	https://www.thekarelab.com/products/anti-virus-iphone-13-pro-max-screen-protector-clear-b2c	180	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-iphone-screen-protector-clear-164333.png?v=1670741161	0	2026-04-10 10:15:47.653354	2026-04-10 07:18:40.627954	2026-04-10 10:15:47.653355	Screen Protectors	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
46	5	Antiviral, antimicrobial iPhone Screen Protector Clear & Anti-Glare	https://www.thekarelab.com/products/anti-virus-iphone-13-pro-max-screen-protector-clear	280	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-iphone-screen-protector-clear-anti-glare-102646.png?v=1648929453	0	2026-04-10 10:15:47.653837	2026-04-10 07:18:40.627955	2026-04-10 10:15:47.653839	Screen Protectors	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
47	5	Face shield	https://www.thekarelab.com/products/face-shield-b2c	85	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/face-shield-454291.png?v=1648929453	0	2026-04-10 10:15:47.654341	2026-04-10 07:18:40.627955	2026-04-10 10:15:47.654342	Work Safety Protective Gear	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
179	8	Amazonite Bracelet	https://energymuse.com/products/amazonite-8mm	18.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/ooak_6_26_-12_edited.png?v=1719423738	0	2026-04-10 10:30:59.099092	2026-04-10 10:30:59.100387	2026-04-10 10:30:59.100388	Energy Muse	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
180	8	Clear quartz with Smoky Quartz Bracelet	https://energymuse.com/products/clear-quartz-with-smoky-quartz-bracelet	24.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/11_1e4b5df9-59da-4282-9988-b83b23bd0906.png?v=1719424756	0	2026-04-10 10:30:59.099782	2026-04-10 10:30:59.100388	2026-04-10 10:30:59.100388	clear quartz with smoky quartz bracelet	\N	f	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
229	9	Golden Love Droplet Pendant With Link Chain	https://www.giva.co/products/golden-love-droplet-pendant-with-link-chain	3099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0502_1_45b46182-53cc-4d0d-9a84-afc971cdaef9.jpg?v=1642401777	0	2026-04-11 05:22:02.722263	2026-04-11 05:22:02.730983	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
1179	26	Certificate of Authenticity	https://crownandpaw.com/products/certificate-of-authenticity	5	USD	\N	0	2026-05-07 03:04:44.479585	2026-05-07 03:04:44.511032	2026-05-15 05:09:37.010697	Crown & Paw	\N	t	t	\N	0	0	culture	shopify	backfill
228	9	Rose Gold Red Baguette Earrings	https://www.giva.co/products/rose-gold-red-baguette-earrings	3499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02588_1.jpg?v=1704370181	0	2026-04-11 05:22:02.721609	2026-04-11 05:22:02.730982	2026-04-11 05:22:02.730982	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
230	9	Rose Gold Sway With Me Earrings	https://www.giva.co/products/silver-lovely-knotting-heart-earring	3499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03316_1_e3d1bbf1-558c-44ae-9a64-02655fa0eaed.jpg?v=1768627349	0	2026-04-11 05:22:02.722877	2026-04-11 05:22:02.730983	2026-04-11 05:22:02.730983	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
232	9	Silver Silver Aura Anklet	https://www.giva.co/products/silver-silver-aura-anklet	4499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0372_2_325ee4d6-35ab-478e-8f00-af3e59ead241.jpg?v=1765271972	0	2026-04-11 05:22:02.723829	2026-04-11 05:22:02.730984	2026-05-15 05:09:37.010697	Anklets	\N	t	\N	\N	0	0	culture	shopify	backfill
231	9	Golden Minimal Gleam Ring	https://www.giva.co/products/golden-minimal-gleam-ring	1199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R03539_1.jpg?v=1764854364	0	2026-04-11 05:22:02.723395	2026-04-11 05:22:02.730983	2026-04-11 05:22:02.730984	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
233	9	Silver Pebble Trail Kids Anklet (0 - 1 Years)	https://www.giva.co/products/silver-pebble-trail-kids-anklet-0-1-years	3699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/KA026_2.jpg?v=1772432148	0	2026-04-11 05:22:02.724344	2026-04-11 05:22:02.730984	2026-05-15 05:09:37.010697	Kids Anklets	\N	t	\N	\N	0	0	culture	shopify	backfill
236	9	Silver Triad of Shine Set	https://www.giva.co/products/silver-triad-of-shine-set	10899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02232_PD02066_1_a262b203-7377-411f-a705-2b28000c55e3.jpg?v=1705389948	0	2026-04-11 05:22:02.726091	2026-04-11 05:22:02.730986	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
239	9	Silver Shining Rose Pendant With Link Chain	https://www.giva.co/products/silver-shining-rose-pendant-with-link-chain	4899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02021_1.jpg?v=1709214191	0	2026-04-11 05:22:02.727717	2026-04-11 05:22:02.730987	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
563	9	Silver Bathinda White Set	https://giva.co/products/silver-bathinda-white-set	19299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03389_ER03751_1.jpg?v=1770874242	0	2026-04-14 03:05:45.99847	2026-04-13 10:51:18.932606	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
234	9	Golden Trielle Ear Piercings	https://www.giva.co/products/golden-trielle-ear-piercings	1399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PER07_1_0092d6ed-3d19-4e1a-8f9a-dda398cbdbd1.jpg?v=1750255676	0	2026-04-11 05:22:02.724949	2026-04-11 05:22:02.730985	2026-04-11 05:22:02.730985	Piercing Earring	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
235	9	Silver Adore Love Bracelet	https://www.giva.co/products/silver-adore-love-bracelet	2399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01138_1.jpg?v=1737034474	0	2026-04-11 05:22:02.725526	2026-04-11 05:22:02.730985	2026-04-11 05:22:02.730985	Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
237	9	Silver Box Chain Bracelet For Him	https://www.giva.co/products/silver-box-chain-bracelet-for-him	6199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLBR0111_1.jpg?v=1767880058	0	2026-04-11 05:22:02.726601	2026-04-11 05:22:02.730986	2026-04-11 05:22:02.730986	Trende Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
238	9	Silver Triad of Shine Necklace	https://www.giva.co/products/silver-triad-of-shine-necklace	10099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02066_1_f853bece-4cac-41b4-a585-855cbf71e7e0.jpg?v=1705389900	0	2026-04-11 05:22:02.727108	2026-04-11 05:22:02.730986	2026-04-11 05:22:02.730987	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
240	9	Rose Gold Heart Beat Set of 4	https://www.giva.co/products/rose-gold-heart-beat-set-of-4	14899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03134_ER03319_BR01418_R02546_1.jpg?v=1768398290	0	2026-04-11 05:22:02.728224	2026-04-11 05:22:02.730987	2026-04-11 05:22:02.730988	Set	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
562	9	Silver Lancaster Crest Necklace	https://giva.co/products/silver-lancaster-crest-necklace	14799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03388_1.jpg?v=1770904339	0	2026-04-14 03:05:45.997014	2026-04-13 10:51:18.932605	2026-04-14 03:05:45.999336	Necklace	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
31	5	KORE Manuka MGO83+ (250g)	https://www.thekarelab.com/products/kore-manuka-mgo83-250g	248	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo83-250g-260493.png?v=1668266679	0	2026-04-10 10:15:47.645645	2026-04-10 07:18:40.627946	2026-04-10 10:15:47.645647	health supplement	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
32	5	KORE Manuka MGO60+ (10g x 30)	https://www.thekarelab.com/products/kore-manuka-mgo60-10g-x-30	368	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo60-10g-x-30-664614.jpg?v=1668526705	0	2026-04-10 10:15:47.646276	2026-04-10 07:18:40.627947	2026-04-10 10:15:47.646277	b2c_product	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
33	5	KORE Manuka MGO263+ (250g)	https://www.thekarelab.com/products/kore-manuka-mgo263-250g	388	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo263-250g-675499.png?v=1668526708	0	2026-04-10 10:15:47.646833	2026-04-10 07:18:40.627948	2026-04-10 10:15:47.646834	b2c_product	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
34	5	KORE Manuka MGO514+ (250g)	https://www.thekarelab.com/products/kore-manuka-mgo514-250g	728	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo514-250g-438870.png?v=1668526707	0	2026-04-10 10:15:47.647427	2026-04-10 07:18:40.627949	2026-04-10 10:15:47.647428	b2c_product	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
35	5	KORE Manuka MGO829+ (250g)	https://www.thekarelab.com/products/kore-manuka-mgo829-250g	1288	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo829-250g-946525.png?v=1668526705	0	2026-04-10 10:15:47.64812	2026-04-10 07:18:40.627949	2026-04-10 10:15:47.648121	b2c_product	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
36	5	Antiviral, Antimicrobial Silver Pull Door Wrap Small	https://www.thekarelab.com/products/copy-of-antiviral-antimicrobial-pull-door-wrap-small	45	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/antiviral-antimicrobial-pull-door-wrap-small-225019.png?v=1681923361	0	2026-04-10 10:15:47.648621	2026-04-10 07:18:40.62795	2026-04-10 10:15:47.648622	Infection Prevention	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
320	9	Silver Colourful Butterfly Pendant with Link Chain	https://giva.co/products/silver-colourful-butterfly-pendant-with-link-chain	4699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02572_1.jpg?v=1747309446	0	2026-04-11 06:24:31.650115	2026-04-11 06:24:31.658013	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
321	9	Golden Princess Set	https://giva.co/products/golden-princess-set	7199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02499_PD02254_5_e37c47d8-5d52-4a22-a09f-b82e0c0d4457.jpg?v=1765039491	0	2026-04-11 06:24:31.650693	2026-04-11 06:24:31.658014	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
322	9	Golden Princess Pendant With Link Chain	https://giva.co/products/golden-princess-pendant-with-link-chain	4099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02254_1.jpg?v=1696080167	0	2026-04-11 06:24:31.651295	2026-04-11 06:24:31.658014	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
323	9	Rose Gold Celestial Swirl Set	https://giva.co/products/rose-gold-celestial-love-set	6899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0816_ER0583.jpg?v=1678201116	0	2026-04-11 06:24:31.651926	2026-04-11 06:24:31.658015	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
315	9	Rose Gold Kirsten Necklace	https://giva.co/products/rose-gold-kirsten-necklace	13199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02950_1.jpg?v=1748524512	0	2026-04-11 06:24:31.646748	2026-04-11 06:24:31.658009	2026-04-11 06:24:31.658009	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
316	9	Silver Tranquil Love Ring	https://giva.co/products/silver-tranquil-love-ring	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01958_1.jpg?v=1737640307	0	2026-04-11 06:24:31.647407	2026-04-11 06:24:31.65801	2026-04-11 06:24:31.65801	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
317	9	Silver Purple Heartie Kids Pendants With Link Chain	https://giva.co/products/silver-heartie-kids-pendants-with-link-chain-1	2799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/KPD014_1.jpg?v=1750689568	0	2026-04-11 06:24:31.648124	2026-04-11 06:24:31.65801	2026-04-11 06:24:31.658011	Kids Pendant	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
318	9	Rose Gold Circular Drop Filigree Earrings	https://giva.co/products/rose-gold-circular-drop-filigree-earrings	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02869_1.jpg?v=1747309732	0	2026-04-11 06:24:31.648883	2026-04-11 06:24:31.658011	2026-04-11 06:24:31.658012	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
319	9	Rose Gold Heart Kids Anklet  (1-5 years)	https://giva.co/products/rose-gold-heart-kids-anklet	899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0439_2_6af8341d-20e0-4d15-938a-5df249562a18.jpg?v=1743166520	0	2026-04-11 06:24:31.64957	2026-04-11 06:24:31.658012	2026-04-11 06:24:31.658013	Anklets	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
324	9	Rose Gold Celestial Love Necklace	https://giva.co/products/star-pendant	4499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0816_1.jpg?v=1656584522	0	2026-04-11 06:24:31.652501	2026-04-11 06:24:31.658015	2026-04-11 06:24:31.658016	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
325	9	Silver Shiny Triangle Pendant With Link Chain	https://giva.co/products/silver-shiny-triangle-pendant-with-link-chain	3199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02544_1.jpg?v=1738852357	0	2026-04-11 06:24:31.65308	2026-04-11 06:24:31.658016	2026-05-15 05:09:37.010697	Pendant	\N	t	\N	\N	0	0	culture	shopify	backfill
183	9	24K Gold Laxmi and Ganesha Coin - 1g	https://www.giva.co/products/24k-gold-laxmi-and-ganesha-coin-1g	17165.98	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDCO018_3_242217cf-0fa9-444f-8197-8a2220c2ce93.jpg?v=1769073398	0	2026-04-10 10:32:37.411168	2026-04-10 10:32:37.428404	2026-05-15 05:09:37.010697	Gold Coin	\N	t	\N	\N	0	0	culture	shopify	backfill
185	9	Rose Gold Sunpetal Filigree Set	https://www.giva.co/products/rose-gold-sunpetal-filigree-set	4899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03732_ER04054_1.jpg?v=1775720225	0	2026-04-10 10:32:37.412854	2026-04-10 10:32:37.428405	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
186	9	Golden Silk Circuit Set	https://www.giva.co/products/golden-silk-circuit-set	4799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03731_ER04053_1.jpg?v=1775721153	0	2026-04-10 10:32:37.413645	2026-04-10 10:32:37.428405	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
190	9	Silver Triple Flora Anklet	https://www.giva.co/products/silver-triple-flora-anklet	2799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0290_2_f02a861c-6faf-4685-ab54-aa5ac2811ec2.jpg?v=1765272060	0	2026-04-10 10:32:37.416201	2026-04-10 10:32:37.428407	2026-05-15 05:09:37.010697	Anklets	\N	t	\N	\N	0	0	culture	shopify	backfill
181	9	Golden Courtesy Ring	https://www.giva.co/products/golden-courtesy-ring	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01353_1.jpg?v=1709214240	0	2026-04-10 10:32:37.409674	2026-04-10 10:32:37.428402	2026-04-10 10:32:37.428403	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
182	9	Silver Butterfly Pearl Dangle Earrings	https://www.giva.co/products/silver-butterfly-pearl-dangle-earrings	2899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER0323_1.jpg?v=1711520326	0	2026-04-10 10:32:37.410441	2026-04-10 10:32:37.428403	2026-04-10 10:32:37.428403	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
184	9	Silver Evangeline Dangler Earrings	https://www.giva.co/products/silver-evangeline-dangler-earrings	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03124_1.jpg?v=1745498313	0	2026-04-10 10:32:37.412069	2026-04-10 10:32:37.428404	2026-04-10 10:32:37.428404	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
187	9	Golden Yellow Flower Kids Bracelet (0-2 years)	https://www.giva.co/products/golden-yellow-flower-kids-bracelet	2299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01233_1_5a8d24d0-024a-4560-a0ce-84bddf720b1b.jpg?v=1742967248	0	2026-04-10 10:32:37.414218	2026-04-10 10:32:37.428406	2026-04-10 10:32:37.428406	Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
188	9	Rose Gold Crossing Waves Ring	https://www.giva.co/products/rose-gold-crossing-waves-ring	2799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01348_1.jpg?v=1709213980	0	2026-04-10 10:32:37.414921	2026-04-10 10:32:37.428406	2026-04-10 10:32:37.428406	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
189	9	Rose Gold Heap of Love Bracelet	https://www.giva.co/products/paisley-bracelet-1	3299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR0353_1_9b3eb7de-9fa4-4310-9c3d-0b6edb880751.jpg?v=1712921424	0	2026-04-10 10:32:37.415539	2026-04-10 10:32:37.428407	2026-04-10 10:32:37.428407	Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
192	9	Golden Aura Tangle Set	https://www.giva.co/products/golden-aura-tangle-set	4999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03729_ER04049_1.jpg?v=1775720619	0	2026-04-10 10:32:37.41742	2026-04-10 10:32:37.428408	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
191	9	Rose Gold Sparkling Heart Ring	https://www.giva.co/products/rose-gold-sparkling-heart-ring	2699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/R072_1_54b0b20d-ee33-4143-8301-9ed2dc1f2088.jpg?v=1631040624	0	2026-04-10 10:32:37.416882	2026-04-10 10:32:37.428408	2026-04-10 10:32:37.428408	Rings	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
327	9	Silver Blue Butterfly Infinity Anklet	https://giva.co/products/silver-blue-butterfly-infinity-anklet	4299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0410_2.jpg?v=1737955521	0	2026-04-11 06:24:31.654246	2026-04-11 06:24:31.658017	2026-05-15 05:09:37.010697	Anklets	\N	t	\N	\N	0	0	culture	shopify	backfill
330	9	Rose Gold Sweet Reverie Set	https://giva.co/products/rose-gold-sweet-reverie-set	9599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03205_ER03452_1.jpg?v=1769258879	0	2026-04-11 06:24:31.655894	2026-04-11 06:24:31.658019	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
37	5	Antiviral, Antimicrobial Silver Button	https://www.thekarelab.com/products/antiviral-antimicrobial-silver-button	42	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/antiviral-antimicrobial-silver-button-139844.png?v=1681923362	0	2026-04-10 10:15:47.649334	2026-04-10 07:18:40.62795	2026-04-10 10:15:47.649336	Infection Prevention	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
38	5	Antiviral, Antimicrobial Silver Pull Door Wrap Large	https://www.thekarelab.com/products/antiviral-antimicrobial-pull-door-wrap	69	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/AclivPullDoorHandleWrap01.png?v=1681897843	0	2026-04-10 10:15:47.649816	2026-04-10 07:18:40.627951	2026-04-10 10:15:47.649818	b2c_product	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
193	9	Rose Gold Magnolia Flower Studs	https://www.giva.co/products/sunflower-earring	3199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0687_1.jpg?v=1694082408	0	2026-04-10 10:32:37.417996	2026-04-10 10:32:37.428408	2026-04-10 10:32:37.428409	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
194	9	Rose Gold Luca Piercing Set	https://www.giva.co/products/rose-gold-luca-piercing-set	4099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PER047_PER048_PER029_1_fce6f897-3006-4949-bbfd-a02057803a8d.jpg?v=1750311407	0	2026-04-10 10:32:37.418569	2026-04-10 10:32:37.428409	2026-04-10 10:32:37.428409	Piercing Earring	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
326	9	Silver Interlocked Heart Duo Bracelet	https://giva.co/products/silver-interlocked-heart-duo-bracelet	5399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR061_1.jpg?v=1713438660	0	2026-04-11 06:24:31.653672	2026-04-11 06:24:31.658017	2026-04-11 06:24:31.658017	Bracelet	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
328	9	Golden Constellation Drop Necklace	https://giva.co/products/golden-constellation-drop-necklace	2999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0381_1.jpg?v=1631893421	0	2026-04-11 06:24:31.654845	2026-04-11 06:24:31.658018	2026-04-11 06:24:31.658018	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
329	9	Silver Aarvik Kada For Him	https://giva.co/products/silver-aarvik-kada-for-him-1	9099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLBR055_1.jpg?v=1765459632	0	2026-04-11 06:24:31.65537	2026-04-11 06:24:31.658018	2026-04-11 06:24:31.658019	Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
49	5	FFP2 NR Face Mask	https://www.thekarelab.com/products/ffp2-nr-face-mask_b2c	50	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/ffp2-nr-face-mask-273096.png?v=1648929460	0	2026-04-10 10:15:47.655329	2026-04-10 07:18:40.627956	2026-04-10 10:15:47.65533	Medical Masks	\N	f	f	\N	0	0	health	shopify	m004|keyword_ma|80
195	9	Rose Gold Flick Ear Piercings	https://www.giva.co/products/rose-gold-flick-ear-piercings	1399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PER055_1_d0982910-9265-4368-a625-948eab34db13.jpg?v=1750255025	0	2026-04-10 10:32:37.419081	2026-04-10 10:32:37.428409	2026-04-10 10:32:37.42841	Piercing Earring	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
196	9	Rose Gold Bloom Ear Piercings	https://www.giva.co/products/rose-gold-bloom-ear-piercings	1399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PER048_1_ed4adbb5-de30-4d2a-bf24-b10794311266.jpg?v=1750311388	0	2026-04-10 10:32:37.41967	2026-04-10 10:32:37.42841	2026-04-10 10:32:37.42841	Piercing Earring	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
197	9	Silver X Stud For Him	https://www.giva.co/products/silver-x-stud-for-him	1299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER0104_5.jpg?v=1759482098	0	2026-04-10 10:32:37.420243	2026-04-10 10:32:37.42841	2026-04-10 10:32:37.428411	Men's Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
198	9	Silver Love Knot Ring	https://www.giva.co/products/silver-love-knot-ring	899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R03603_1_c1c76518-7615-4529-b3c8-c7998daff636.jpg?v=1770198602	0	2026-04-10 10:32:37.420823	2026-04-10 10:32:37.428411	2026-04-10 10:32:37.428411	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
199	9	Rose Gold Circle of Life Mangalsutra Bracelet	https://www.giva.co/products/circle-charm-rose-gold-bracelet	2799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/BR0549_1-min.jpg?v=1662038413	0	2026-04-10 10:32:37.421555	2026-04-10 10:32:37.428411	2026-04-10 10:32:37.428412	Mangalsutra	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
200	9	Oxidised Silver Huggie Hoop Earring for Him	https://www.giva.co/products/oxidised-silver-huggie-hoop-earring-for-him	2599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER097_1_19bfbb64-d6d6-4617-b824-30682783e344.jpg?v=1763031688	0	2026-04-10 10:32:37.421994	2026-04-10 10:32:37.428412	2026-04-10 10:32:37.428412	Men's Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
201	9	Golden Cirque Ring	https://www.giva.co/products/golden-cirque-ring	3799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01338_1.jpg?v=1709214729	0	2026-04-10 10:32:37.422579	2026-04-10 10:32:37.428412	2026-04-10 10:32:37.428412	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
202	9	Golden Star Constellation Ring	https://www.giva.co/products/golden-star-constellation-ring	1099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R0126_1.jpg?v=1711630616	0	2026-04-10 10:32:37.423111	2026-04-10 10:32:37.428413	2026-04-10 10:32:37.428413	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
203	9	Golden Star Constellation Set	https://www.giva.co/products/golden-star-constellation-set	5699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/SET0205_1_f55cf774-1e0c-487a-9f63-dcea8e45e717.jpg?v=1675930720	0	2026-04-10 10:32:37.423716	2026-04-10 10:32:37.428413	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
204	9	Golden Pali Jhumki Earrings	https://www.giva.co/products/golden-pali-jhumki-earrings	6499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03608_1.jpg?v=1775718848	0	2026-04-10 10:32:37.424208	2026-04-10 10:32:37.428414	2026-04-10 10:32:37.428414	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
205	9	Silver Trinity Adjustable Ring	https://www.giva.co/products/silver-trinity-adjustable-ring	4299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R03717_1.jpg?v=1775720251	0	2026-04-10 10:32:37.424661	2026-04-10 10:32:37.428414	2026-04-10 10:32:37.428414	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
206	9	Rose Gold Luminous Bow Ring	https://www.giva.co/products/rose-gold-luminous-bow-ring	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R03709_1.jpg?v=1775728250	0	2026-04-10 10:32:37.425205	2026-04-10 10:32:37.428415	2026-04-10 10:32:37.428415	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
207	9	Rose Gold Sparkling Spirits Vanki Ring	https://www.giva.co/products/rose-gold-sparkling-spirits-vanki-ring	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01782_1.jpg?v=1729168735	0	2026-04-10 10:32:37.425665	2026-04-10 10:32:37.428415	2026-04-10 10:32:37.428415	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
209	9	Silver Twist Toe Rings	https://www.giva.co/products/silver-twist-toe-rings	1199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TR0201_1_423d55ec-e361-4513-b087-4d40f00e744d.jpg?v=1764062497	0	2026-04-10 10:32:37.426744	2026-04-10 10:32:37.428416	2026-04-10 10:32:37.428417	Toe Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
210	9	Golden Pushkar Jhumki Earrings	https://www.giva.co/products/golden-pushkar-jhumki-earrings	5899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03432_1.jpg?v=1775719558	0	2026-04-10 10:32:37.427275	2026-04-10 10:32:37.428417	2026-04-10 10:32:37.428417	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
273	6	Sunshine & Rainbows Coconut Bowls	https://coconutbowls.com/products/sunshine-coconut-bowl	8.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/26_1ad2ecf6-5af7-4a13-b026-c753fe950879.jpg?v=1683502398	0	2026-04-21 10:23:12.010968	2026-04-11 06:01:47.027796	2026-04-21 10:23:12.031209	Coconut Bowl	\N	t	f	2026-04-11 07:54:51.51034	0	0	\N	shopify	m004|uncategori|0
630	21	Linen Easy Short | Navy	https://everlane.com/products/mens-linen-easy-short-navy	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/b6b8e17e_9ebf.jpg?v=1776290402	0	2026-04-16 10:38:40.033094	2026-04-16 10:29:07.014609	2026-04-16 10:38:40.048703	algolia-ignore	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
581	9	Golden Loretta Earrings	https://giva.co/products/golden-loretta-earrings	2799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03173_1.jpg?v=1752731410	0	2026-04-14 03:05:45.964299	2026-04-14 03:05:46.001232	2026-04-14 03:05:46.001232	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
582	9	Silver Dendrobium Ring	https://giva.co/products/silver-dendrobium-ring	1599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01970_1.jpg?v=1732027792	0	2026-04-14 03:05:45.966618	2026-04-14 03:05:46.001233	2026-04-14 03:05:46.001233	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
583	9	Silver Shining Love Couple Rings	https://giva.co/products/silver-shining-love-couple-rings	5599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/E0259_1_1.jpg?v=1642778133	0	2026-04-14 03:05:45.968038	2026-04-14 03:05:46.001234	2026-04-14 03:05:46.001234	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
584	9	Rose Gold Chirpy Ring	https://giva.co/products/rose-gold-chirpy-ring	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01690_1.jpg?v=1716988609	0	2026-04-14 03:05:45.969321	2026-04-14 03:05:46.001234	2026-04-14 03:05:46.001234	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
585	9	Silver Delphi Ear Piercings	https://giva.co/products/silver-delphi-ear-piercings	1799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PER039_1_64799d39-5fa6-4df8-b772-bc3752db1b78.jpg?v=1750258035	0	2026-04-14 03:05:45.970646	2026-04-14 03:05:46.001235	2026-04-14 03:05:46.001235	Piercing Earring	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
588	9	Silver Pink Square Earrings	https://giva.co/products/silver-pink-square-earrings	3899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02811_1.jpg?v=1726746773	0	2026-04-14 03:05:45.974544	2026-04-14 03:05:46.001236	2026-04-14 03:05:46.001236	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
589	9	Silver Breeze Leaf Earrings	https://giva.co/products/silver-breeze-leaf-earrings	2399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02935_1.jpg?v=1747914730	0	2026-04-14 03:05:45.977251	2026-04-14 03:05:46.001237	2026-04-14 03:05:46.001237	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
590	9	Silver Love In A Day Earrings	https://giva.co/products/silver-love-in-a-day-earrings	3299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02575_1.jpg?v=1704370128	0	2026-04-14 03:05:45.979738	2026-04-14 03:05:46.001237	2026-04-14 03:05:46.001237	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
593	9	Silver Met Love Bracelet	https://giva.co/products/silver-met-love-bracelet	2999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01145_1.jpg?v=1736428998	0	2026-04-14 03:05:45.982647	2026-04-14 03:05:46.001239	2026-04-14 03:05:46.001239	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
594	9	24K Gold Laxmi and Ganesha Coin - 1g	https://giva.co/products/24k-gold-laxmi-and-ganesha-coin-1g	17134.05	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDCO018_3_242217cf-0fa9-444f-8197-8a2220c2ce93.jpg?v=1769073398	0	2026-04-14 03:05:45.983774	2026-04-14 03:05:46.001239	2026-05-15 05:09:37.010697	Gold Coin	\N	t	t	\N	0	0	culture	shopify	backfill
595	9	Gold Hello Sunshine Lab Grown Diamond Pendant	https://giva.co/products/gold-hello-sunshine-lab-grown-diamond-pendant	15596.45	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDLPD0820_1.jpg?v=1770876732	0	2026-04-14 03:05:45.984849	2026-04-14 03:05:46.001239	2026-05-15 05:09:37.010697	Gold Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
596	9	Rose Gold Chloris Dangler Earrings	https://giva.co/products/rose-gold-chloris-dangler-earrings	3599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03107_1.jpg?v=1744291859	0	2026-04-14 03:05:45.986095	2026-04-14 03:05:46.00124	2026-04-14 03:05:46.00124	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
597	9	Golden Personalised Classy Om Heartbeat Bracelet	https://giva.co/products/golden-personalised-classy-om-heartbeat-bracelet	3099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PX561_pre.jpg?v=1775803613	0	2026-04-14 03:05:45.987119	2026-04-14 03:05:46.00124	2026-04-14 03:05:46.001241	Bracelet	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
598	9	Silver Kate Earrings	https://giva.co/products/silver-kate-earrings	1599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03176_1.jpg?v=1748518007	0	2026-04-14 03:05:45.988241	2026-04-14 03:05:46.001241	2026-04-14 03:05:46.001241	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
599	9	Silver Branchful Necklace	https://giva.co/products/silver-branchful-necklace	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02234_1.jpg?v=1709214897	0	2026-04-14 03:05:45.989342	2026-04-14 03:05:46.001241	2026-04-14 03:05:46.001242	Pendant	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
600	9	Rose Gold Celebrating Bracelet	https://giva.co/products/rose-gold-celebrating-bracelet	8699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01241_1.jpg?v=1744885823	0	2026-04-14 03:05:45.990251	2026-04-14 03:05:46.001242	2026-04-14 03:05:46.001242	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
601	9	Rose Gold Choosing You Necklace	https://giva.co/products/rose-gold-choosing-you-necklace	3999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03128_1.jpg?v=1769065770	0	2026-04-14 03:05:45.991227	2026-04-14 03:05:46.001242	2026-04-14 03:05:46.001243	Pendant	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
631	21	Pointed-Toe Slingback Heel | Rouge	https://everlane.com/products/womens-pointed-toe-slingback-heel-rouge	228	USD	\N	0	2026-04-16 10:38:40.034966	2026-04-16 10:29:07.01461	2026-04-16 10:38:40.048704	Flats + Other	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
640	21	Archive Cotton Relaxed-Fit Crew | White	https://everlane.com/products/mens-archive-cotton-relaxed-fit-crew-white	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/0b8ed99b_e95b.jpg?v=1775682003	0	2026-04-16 10:38:40.039273	2026-04-16 10:29:07.014615	2026-04-16 10:38:40.048705	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
641	21	Archive Cotton Relaxed-Fit Crew | Midnight Navy	https://everlane.com/products/mens-archive-cotton-relaxed-fit-crew-midnight-navy	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/cdadc451_d6cf.jpg?v=1775595603	0	2026-04-16 10:38:40.039684	2026-04-16 10:29:07.014616	2026-04-16 10:38:40.048706	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
642	21	Archive Cotton Relaxed-Fit Crew | Heathered Oatmeal	https://everlane.com/products/mens-archive-cotton-relaxed-fit-crew-heathered-oatmeal	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/4d691dff_52f9.jpg?v=1775592008	0	2026-04-16 10:38:40.04019	2026-04-16 10:29:07.014616	2026-04-16 10:38:40.048706	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
643	21	Archive Cotton Relaxed-Fit Crew | Vintage Heather Grey	https://everlane.com/products/mens-archive-cotton-relaxed-fit-crew-vintage-heather-grey	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/9a45ba07_ea04.jpg?v=1774378815	0	2026-04-16 10:38:40.040645	2026-04-16 10:29:07.014617	2026-04-16 10:38:40.048706	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
644	21	Archive Cotton Relaxed-Fit Crew | Mocha	https://everlane.com/products/mens-archive-cotton-relaxed-fit-crew-mocha	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/dbb5d919_38fb.jpg?v=1774378816	0	2026-04-16 10:38:40.041094	2026-04-16 10:29:07.014618	2026-04-16 10:38:40.048706	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
361	9	(Pair) Silver Evil Eye Cutie Kids Anklet	https://giva.co/products/pair-silver-evil-eye-cutie-kids-anklet	2399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/KA03_2_995d9f48-91fb-4860-b6f2-111581e8efcc.jpg?v=1750757416	0	2026-04-11 06:28:11.484774	2026-04-11 06:28:11.49985	2026-05-15 05:09:37.010697	Kids Anklets	\N	t	\N	\N	0	0	culture	shopify	backfill
362	9	18k Gold Floral Flare Diamond Mangalsutra	https://giva.co/products/18k-gold-floral-flare-diamond-mangalsutra	35587.2	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDLNE03_1.jpg?v=1683810320	0	2026-04-11 06:28:11.485455	2026-04-11 06:28:11.499851	2026-05-15 05:09:37.010697	Gold Mangalsutra	\N	f	\N	\N	0	0	culture	shopify	backfill
363	9	999 Silver Bar  - 50g	https://giva.co/products/silver-50gm-giva-coin	21999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/CO044_5.jpg?v=1682054724	0	2026-04-11 06:28:11.486132	2026-04-11 06:28:11.499852	2026-05-15 05:09:37.010697	Coin	\N	f	\N	\N	0	0	culture	shopify	backfill
364	9	999 Silver Coin - Swastika (5g)	https://giva.co/products/999-silver-coin-swastika-5g	1899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/CO0011_3_1.jpg?v=1682060577	0	2026-04-11 06:28:11.48688	2026-04-11 06:28:11.499852	2026-05-15 05:09:37.010697	Coin	\N	f	\N	\N	0	0	culture	shopify	backfill
365	9	999 Silver Goddess Lakshmi and Lord Ganesh Coin - 10 g	https://giva.co/products/999-silver-goddess-lakshmi-and-lord-ganesh-coin-10-g	3799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/CO039_5.jpg?v=1682054927	0	2026-04-11 06:28:11.487466	2026-04-11 06:28:11.499853	2026-05-15 05:09:37.010697	Coin	\N	t	\N	\N	0	0	culture	shopify	backfill
366	9	999 Silver Peacock Beauty Coin- 20g	https://giva.co/products/peacock-10gms-1	7599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/CO020_5_5.jpg?v=1682054782	0	2026-04-11 06:28:11.487985	2026-04-11 06:28:11.499854	2026-04-11 06:28:11.499854	Coin	\N	f	\N	\N	0	0	beauty	shopify	m004|keyword_ma|80
367	9	Aaj Sajeya Earrings	https://giva.co/products/aaj-sajeya-earrings	4099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02544_1.jpg?v=1709114510	0	2026-04-11 06:28:11.488565	2026-04-11 06:28:11.499854	2026-04-11 06:28:11.499855	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
368	9	Aayesha’s Rose Gold Wing Studs	https://giva.co/products/aayesha-s-rose-gold-wing-studs	3299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER0187_1.jpg?v=1627033956	0	2026-04-11 06:28:11.489078	2026-04-11 06:28:11.499855	2026-04-11 06:28:11.499855	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
369	9	Air and Aura Gift Combo	https://giva.co/products/air-and-aura-gift-combo	3499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PR048_R016.png?v=1775216022	0	2026-04-11 06:28:11.48956	2026-04-11 06:28:11.499856	2026-04-11 06:28:11.499856	Perfume	\N	t	\N	\N	0	0	beauty	shopify	m004|keyword_ma|80
370	9	Anushka Sharma Classic Rose Gold Set with Box Chain	https://giva.co/products/classic-rose-gold-set	9999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/Set047_1.jpg?v=1627033511	0	2026-04-11 06:28:11.490038	2026-04-11 06:28:11.499856	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
371	9	Anushka Sharma Classic Silver Zircon Set	https://giva.co/products/classic-zircon-set	4999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD059_ER005_5.jpg?v=1765039665	0	2026-04-11 06:28:11.490573	2026-04-11 06:28:11.499857	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
372	9	Anushka Sharma French Rose Necklace	https://giva.co/products/anushka-sharma-french-rose-necklace	16499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0470_1.jpg?v=1681389183	0	2026-04-11 06:28:11.491175	2026-04-11 06:28:11.499858	2026-04-11 06:28:11.499858	Necklace	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
373	9	Anushka Sharma Golden Blooming Flower Ring	https://giva.co/products/anushka-sharma-golden-blooming-flower-ring	2999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/R0754_1-min.jpg?v=1672933081	0	2026-04-11 06:28:11.491673	2026-04-11 06:28:11.499858	2026-04-11 06:28:11.499859	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
374	9	Anushka Sharma Golden Blooming Flower Stud Earrings	https://giva.co/products/golden-blooming-flower-stud-earrings	2899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0292_5_9a024dda-912e-4d77-bd41-ffbd64eb92cc.jpg?v=1742392651	0	2026-04-11 06:28:11.492123	2026-04-11 06:28:11.499859	2026-04-11 06:28:11.499859	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
375	9	Anushka Sharma Golden Crescent Zircon Tiny Earrings	https://giva.co/products/the-golden-crescent-zircon-earrings	1199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0593_1.jpg?v=1703764687	0	2026-04-11 06:28:11.4926	2026-04-11 06:28:11.49986	2026-04-11 06:28:11.49986	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
376	9	Anushka Sharma Golden Gleam Dream Ring	https://giva.co/products/anushka-sharma-golden-gleam-dream-ring	2699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R0752_1.jpg?v=1713439748	0	2026-04-11 06:28:11.493082	2026-04-11 06:28:11.49986	2026-04-11 06:28:11.49986	Rings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
377	9	Anushka Sharma Golden Radiant Sunrise Necklace	https://giva.co/products/golden-radiant-sunrise-necklace	3899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD0225_1.jpg?v=1697121052	0	2026-04-11 06:28:11.493597	2026-04-11 06:28:11.499861	2026-04-11 06:28:11.499861	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
378	9	Anushka Sharma Golden Rhythm Of The Night Necklace	https://giva.co/products/anushka-sharma-golden-rhythm-of-the-night-necklace	10299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD01872_1.jpg?v=1681465601	0	2026-04-11 06:28:11.494056	2026-04-11 06:28:11.499861	2026-04-11 06:28:11.499862	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
381	9	Anushka Sharma Golden Star Constellation Pendant Set	https://giva.co/products/golden-star-constellation-pendant-set	4699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER0462_PD0218_1-min.jpg?v=1680000819	0	2026-04-11 06:28:11.495365	2026-04-11 06:28:11.499863	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
383	9	Anushka Sharma Moonlight Pearl Set	https://giva.co/products/moonlight-pearl-set	4099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/SET001_1.png?v=1691736908	0	2026-04-11 06:28:11.496193	2026-04-11 06:28:11.499865	2026-05-15 05:09:37.010697	Set	\N	t	\N	\N	0	0	culture	shopify	backfill
379	9	Anushka Sharma Golden Secret Heart Pendant with Link Chain	https://giva.co/products/anushka-sharma-golden-wings-of-love-pendant-with-link-chain	4799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD01712_1-min.jpg?v=1673528431	0	2026-04-11 06:28:11.494482	2026-04-11 06:28:11.499862	2026-04-11 06:28:11.499862	Pendant	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
380	9	Anushka Sharma Golden Star Constellation Necklace	https://giva.co/products/golden-star-constellation-necklace	2999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD0218_1_18ac8de0-3c62-4ab1-87b3-601ef392314e.jpg?v=1712927159	0	2026-04-11 06:28:11.494901	2026-04-11 06:28:11.499863	2026-04-11 06:28:11.499863	Pendant	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
382	9	Anushka Sharma Golden Star Constellation Tiny Studs	https://giva.co/products/golden-star-constellation-studs	1499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0462_1.jpg?v=1711630356	0	2026-04-11 06:28:11.49579	2026-04-11 06:28:11.499864	2026-04-11 06:28:11.499864	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
384	9	Anushka Sharma Pink Quartz Flower Combo	https://giva.co/products/anushka-sharma-pink-quartz-flower-combo	6999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD0228_ER02531_1.jpg?v=1708611246	0	2026-04-11 06:28:11.496684	2026-04-11 06:28:11.499865	2026-04-11 06:28:11.499866	Set	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
385	9	Anushka Sharma Pink Quartz Flower Essential Set	https://giva.co/products/anushka-sharma-pink-quartz-flower-essential-set	9499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD0228_ER02531_R01613_1.jpg?v=1708611361	0	2026-04-11 06:28:11.497142	2026-04-11 06:28:11.499866	2026-04-11 06:28:11.499866	Set	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
386	9	Anushka Sharma Rose Gold Charm Hoop Earrings	https://giva.co/products/rose-gold-chunky-charm-hoops	4499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0575_1.jpg?v=1721907520	0	2026-04-11 06:28:11.497577	2026-04-11 06:28:11.499867	2026-04-11 06:28:11.499867	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
387	9	Anushka Sharma Rose Gold Cherry Bow Heart Ring	https://giva.co/products/rose-gold-cherry-bow-heart-ring	2299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R081_1-min.jpg?v=1685018874	0	2026-04-11 06:28:11.49799	2026-04-11 06:28:11.499867	2026-04-11 06:28:11.499867	Rings	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
388	9	Anushka Sharma Rose Gold Classic Earrings	https://giva.co/products/classic-rose-gold-set-earring	5499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER0496_1.jpg?v=1674466424	0	2026-04-11 06:28:11.498393	2026-04-11 06:28:11.499868	2026-04-11 06:28:11.499868	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
389	9	Anushka Sharma Rose Gold Crown Bracelet	https://giva.co/products/anushka-sharma-rose-gold-crown-bracelet	2899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR048_1.jpg?v=1747306258	0	2026-04-11 06:28:11.498822	2026-04-11 06:28:11.499869	2026-04-11 06:28:11.499869	Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
390	9	Anushka Sharma Rose Gold Deer Bracelet	https://giva.co/products/rose-gold-deer-bracelet	3699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR0141_1.jpg?v=1714041724	0	2026-04-11 06:28:11.499293	2026-04-11 06:28:11.499869	2026-04-11 06:28:11.499869	Bracelet	\N	t	\N	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
391	8	Malachite Crystal Point	https://energymuse.com/products/malachite-crystal-point	34.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/products/malachitepoint-energymuse.png?v=1647371985	0	2026-04-21 10:23:08.859724	2026-04-11 06:31:33.849695	2026-04-21 10:23:08.884202	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
392	8	Malachite Slice	https://energymuse.com/products/malachite-slice	58.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/MalachiteSlice_1.png?v=1775766434	0	2026-04-21 10:23:08.860737	2026-04-11 06:31:33.849697	2026-04-21 10:23:08.884202	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
393	8	Malachite Pendant Necklace	https://energymuse.com/products/malachite-pendant-necklace-1	58.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/MalachitePendantNecklace_3.png?v=1775762878	0	2026-04-21 10:23:08.861609	2026-04-11 06:31:33.849698	2026-04-21 10:23:08.884202	Jewelry	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
394	8	Manifestation Magnet Necklace	https://energymuse.com/products/manifestation-magnet-necklace	188.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/NaturalCitrinePendantNecklace.png?v=1775762732	0	2026-04-21 10:23:08.862441	2026-04-11 06:31:33.849699	2026-04-21 10:23:08.884203	Jewelry	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
645	21	Archive Standard-Fit Cotton Crew | Heathered Oatmeal	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-heathered-oatmeal	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/31d4c492_ff9e.jpg?v=1774375214	0	2026-04-16 10:38:40.041506	2026-04-16 10:29:07.014618	2026-04-16 10:38:40.048706	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1170	27	Cork Camera Set	https://papershoot.com/products/cork-camera-set	170	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera-20Secret_Garde.png?v=1764751474	0	2026-05-14 07:20:29.403762	2026-05-07 03:04:39.920376	2026-05-15 05:09:37.010697	Add On Discount (Bundle Camera)	\N	t	t	\N	0	0	culture	shopify	backfill
646	21	Archive Cotton Relaxed-Fit Crew | Agave Green	https://everlane.com/products/mens-archive-cotton-relaxed-fit-crew-agave-green	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/0fdc58e2_ae73.jpg?v=1774378815	0	2026-04-16 10:38:40.041961	2026-04-16 10:29:07.014619	2026-04-16 10:38:40.048707	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
647	21	Archive Cotton Relaxed-Fit Crew | Black	https://everlane.com/products/mens-archive-cotton-relaxed-fit-crew-black	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/635c8f3d_9671.jpg?v=1774378814	0	2026-04-16 10:38:40.042346	2026-04-16 10:29:07.014619	2026-04-16 10:38:40.048707	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
271	6	Starter Set	https://coconutbowls.com/products/starter-set-1	33.97	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/4_85d04da0-f87a-47c1-8b4f-8eb164f76791.jpg?v=1646093725	0	2026-04-21 10:23:12.007875	2026-04-11 06:01:47.027795	2026-04-21 10:23:12.031208	Bundle	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
272	6	Bamboo Cup Bundle	https://coconutbowls.com/products/bamboo-cup-bundle	17.77	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/image_-_3845766.jpg?v=1732781929	0	2026-04-21 10:23:12.010045	2026-04-11 06:01:47.027796	2026-04-21 10:23:12.031209	Bundle	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
648	21	Archive Standard-Fit Cotton Crew | White	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-white	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/583e9316_95fd.jpg?v=1775592006	0	2026-04-16 10:38:40.04278	2026-04-16 10:29:07.01462	2026-04-16 10:38:40.048707	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
299	6	Wave Spoons	https://coconutbowls.com/products/wave-spoon	4.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/11_9563e853-d619-407b-b3f7-97fa4512787c.jpg?v=1634258756	0	2026-04-21 10:23:12.029557	2026-04-11 06:01:47.027806	2026-04-21 10:23:12.031224	Accessories	\N	f	f	2026-04-11 07:34:56.655026	0	0	fashion-accessories	shopify	m004|keyword_ma|80
300	6	Sea Shepherd Coconut Bowls	https://coconutbowls.com/products/sea-shepherd-coconut-bowl	8.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/4_6c97644f-117f-405c-8c69-963ba9c6ee09.png?v=1678237927	0	2026-04-21 10:23:12.030047	2026-04-11 06:01:47.027806	2026-04-21 10:23:12.031224	Coconut Bowl	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
649	21	Archive Standard-Fit Cotton Crew | Midnight Navy	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-midnight-navy	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/bf59c3a7_c3f8.jpg?v=1774375215	0	2026-04-16 10:38:40.043166	2026-04-16 10:29:07.01462	2026-04-16 10:38:40.048707	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
650	21	Archive Standard-Fit Cotton Crew | Burnished Lilac	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-burnished-lilac	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/4f8a0b87_ca12.jpg?v=1775844003	0	2026-04-16 10:38:40.043554	2026-04-16 10:29:07.014621	2026-04-16 10:38:40.048707	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
651	21	Archive Standard-Fit Cotton Crew | Vintage Heather Grey	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-vintage-heather-grey	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/1e96583c_45a9.jpg?v=1774375214	0	2026-04-16 10:38:40.043996	2026-04-16 10:29:07.014622	2026-04-16 10:38:40.048708	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
661	29	Keychron G3 Ultra Light Wireless Mouse	https://keychron.com/products/keychron-g3-ultra-light-wireless-mouse	109.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/G3-Mouse-Features.jpg?v=1776321647	0	2026-05-14 07:21:29.220353	2026-04-16 10:29:10.034068	2026-05-15 05:09:37.010697	Mice	\N	t	t	\N	0	0	culture	shopify	backfill
786	36	LastPad	https://lastobject.com/products/lastpad	18	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/1_Hero_L_Black.png?v=1742478455	0	2026-05-14 07:20:40.120475	2026-04-16 10:29:20.122636	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
749	38	Black Tourmaline Sphere - Large - 1 of a Kind	https://tinyrituals.co/products/black-tourmaline-sphere-large	178	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/1_07e49ccd-3c0c-4c97-8e5e-bff68d55ebd3.jpg?v=1776227725	0	2026-05-14 07:21:51.42413	2026-04-16 10:29:17.594861	2026-05-14 07:21:51.432551	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
652	21	Archive Standard-Fit Cotton Crew | Mocha	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-mocha	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/ebf1703b_7b98.jpg?v=1774375214	0	2026-04-16 10:38:40.044368	2026-04-16 10:29:07.014622	2026-04-16 10:38:40.048708	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
653	21	Archive Standard-Fit Cotton Crew | Black	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-black	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/069d29f0_369e.jpg?v=1774375213	0	2026-04-16 10:38:40.044974	2026-04-16 10:29:07.014623	2026-04-16 10:38:40.048708	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
654	21	Archive Standard-Fit Cotton Crew | Agave Green	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-agave-green	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/7c4bfa31_45ca.jpg?v=1774375215	0	2026-04-16 10:38:40.045534	2026-04-16 10:29:07.014623	2026-04-16 10:38:40.048708	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
655	21	Vintage Rib Tank | Heathered Oatmeal	https://everlane.com/products/mens-vintage-rib-tank-heathered-oatmeal	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/f3553537_cd19.jpg?v=1774375212	0	2026-04-16 10:38:40.046142	2026-04-16 10:29:07.014624	2026-04-16 10:38:40.048708	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
656	21	Vintage Rib Tank | Beech	https://everlane.com/products/mens-vintage-rib-tank-beech	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/3eb7a640_9f79.jpg?v=1774375212	0	2026-04-16 10:38:40.046545	2026-04-16 10:29:07.014624	2026-04-16 10:38:40.048709	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
657	21	Seed Stitch Polo | Open Air Blue	https://everlane.com/products/mens-seed-stitch-polo-open-air-blue	128	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/b589a8cc_d942.jpg?v=1774375211	0	2026-04-16 10:38:40.046938	2026-04-16 10:29:07.014625	2026-04-16 10:38:40.048709	Sweaters	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
658	21	Seed Stitch Polo | Birch	https://everlane.com/products/mens-seed-stitch-polo-birch	128	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/044f9ecd_6960.jpg?v=1774375211	0	2026-04-16 10:38:40.047861	2026-04-16 10:29:07.014626	2026-04-16 10:38:40.048709	Sweaters	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
659	29	Keychron V6 HE Magnetic Switch Keyboard (Limited Edition to Specific Region)	https://keychron.com/products/keychron-v6-he-magnetic-switch-keyboard	169.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/V6HE.jpg?v=1774595225	0	2026-05-14 07:21:29.219304	2026-04-16 10:29:10.034066	2026-05-14 07:21:29.229548	Custom Keyboards	\N	f	f	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
660	29	Keychron V1 HE Magnetic Switch Keyboard (Limited Edition to Specific Region)	https://keychron.com/products/keychron-v1-he-magnetic-switch-keyboard	159.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/V1HE.jpg?v=1774597816	0	2026-05-14 07:21:29.219829	2026-04-16 10:29:10.034067	2026-05-14 07:21:29.229549	Custom Keyboards	\N	f	f	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
662	29	Keychron R3 QMK Wireless Mechanical Keyboard	https://keychron.com/products/keychron-r3-qmk-wireless-mechanical-keyboard	79.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron_R3_QMK_Wireless_Mechanical_Keyboard-red.png?v=1769505124	0	2026-05-14 07:21:29.220848	2026-04-16 10:29:10.034068	2026-05-14 07:21:29.22955	Custom Keyboards	\N	f	f	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
663	29	Keychron C3 HE Wired Magnetic Switch Keyboard	https://keychron.com/products/keychron-c3-he-magnetic-switch-keyboard	89.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-C3-HE-Wired-Magnetic-Switch-Keyboard_c18aab9f-067a-4317-82d5-c5f85cf40832.jpg?v=1775801595	0	2026-05-14 07:21:29.221304	2026-04-16 10:29:10.034069	2026-05-14 07:21:29.22955	Custom Keyboards	\N	f	f	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
664	29	Keychron K3 Max SE QMK Wireless Custom Mechanical Keyboard	https://keychron.com/products/keychron-k3-max-se-qmk-wireless-custom-mechanical-keyboard	104.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-K3-Max-SE-features.jpg?v=1774505925	0	2026-05-14 07:21:29.221701	2026-04-16 10:29:10.034069	2026-05-14 07:21:29.22955	Slim Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
790	36	Beauty Kit	https://lastobject.com/products/ultimate-beauty-kit	33	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/products/beauty-kit-bundle-lastobject-432651.jpg?v=1686049043	0	2026-05-14 07:20:40.122063	2026-04-16 10:29:20.122638	2026-05-14 07:20:40.128521	Bundle	\N	t	t	\N	0	0	beauty	shopify	m004|keyword_ma|80
791	36	LastSwab	https://lastobject.com/products/lastswab	12	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/LS-O-Turq-1_b.png?v=1773924039	0	2026-05-14 07:20:40.122415	2026-04-16 10:29:20.122639	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
792	36	LastRound	https://lastobject.com/products/lastround	16	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/LR-R-Turq-1.png?v=1769182162	0	2026-05-14 07:20:40.122752	2026-04-16 10:29:20.122639	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
793	36	LastTissue	https://lastobject.com/products/lasttissue	24	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/LT-P-Turq-1.jpg?v=1769073255	0	2026-05-14 07:20:40.123084	2026-04-16 10:29:20.12264	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
794	36	Facial Cleanser Bottle	https://lastobject.com/products/facial-cleanser-bottle	5	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Carousel_Facial_Cleanser_Bottle_1_1992a2e9-2370-40e2-8ca6-d033f43c9dcb.jpg?v=1713863656	0	2026-05-14 07:20:40.123465	2026-04-16 10:29:20.12264	2026-05-15 05:09:37.010697	Powder Soaps	\N	t	t	\N	0	0	beauty	shopify	backfill
795	36	Body Wash Bottle	https://lastobject.com/products/body-wash-bottle	5	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Carousel_Body_Wash_Bottle_1_3548aaea-a597-455e-b3e7-311a4286aaab.jpg?v=1713863594	0	2026-05-14 07:20:40.123803	2026-04-16 10:29:20.122641	2026-05-15 05:09:37.010697	Powder Soaps	\N	t	t	\N	0	0	beauty	shopify	backfill
399	9	GIVA Signature Set	https://giva.co/products/giva-signature-set-1	18299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/GIVASignatureSet_1.jpg?v=1654597643	0	2026-04-11 08:12:07.659582	2026-04-11 08:12:07.676646	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
307	9	Silver Zircon Bubble Stud Earrings	https://giva.co/products/hexagon-shape-stone-classie-stud-earring	999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER01287_1.jpg?v=1752833398	0	2026-04-11 08:12:07.664141	2026-04-11 06:24:31.658004	2026-04-11 08:12:07.674909	Earrings	\N	t	\N	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
398	9	Silver Granada Rouge Red Necklace	https://giva.co/products/silver-granada-rouge-red-necklace	13699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03376_1.jpg?v=1770904241	0	2026-04-11 08:12:07.65835	2026-04-11 08:12:07.676645	2026-04-11 08:12:07.676646	Necklace	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
400	9	GIVA Classic Solitaire Bracelet	https://giva.co/products/giva-solitaire-bracelet	6499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/BR058_1_9a550c51-304a-4fc8-bbab-3d0d3db7c2a4.jpg?v=1625905460	0	2026-04-11 08:12:07.660354	2026-04-11 08:12:07.676647	2026-04-11 08:12:07.676647	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
401	9	Silver Digital Dazzle Stud For Him	https://giva.co/products/silver-digital-dazzle-stud-for-him	1099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER072_1.jpg?v=1761652993	0	2026-04-11 08:12:07.661068	2026-04-11 08:12:07.676647	2026-04-11 08:12:07.676647	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
402	9	Golden Indigo Teardrop Earrings	https://giva.co/products/golden-indigo-teardrop-earrings	1399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02437_1.jpg?v=1699524364	0	2026-04-11 08:12:07.661638	2026-04-11 08:12:07.676647	2026-04-11 08:12:07.676648	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
403	9	Silver Shiny Leaf Bracelet	https://giva.co/products/leaf-with-stoned-bangle	8899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/BR0480_1-min.jpg?v=1665665467	0	2026-04-11 08:12:07.662117	2026-04-11 08:12:07.676648	2026-04-11 08:12:07.676648	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
404	9	Golden Daisy Affair Pendant with Link Chain	https://giva.co/products/sunstar-sparkle-pendant	5899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD01718_1.jpg?v=1674735484	0	2026-04-11 08:12:07.662607	2026-04-11 08:12:07.676648	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
410	9	Dual Tone Majestic Rhombus Pendant With Link Chain	https://giva.co/products/dual-tone-majestic-rhombus-pendant-with-link-chain	4999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02583_1.jpg?v=1738848249	0	2026-04-11 08:12:07.666249	2026-04-11 08:12:07.676651	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
413	9	Silver Sparkling Zirconia Pendant With Link Chain	https://giva.co/products/silver-zircon-pendant	3799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02432_1.jpg?v=1735916811	0	2026-04-14 03:05:45.975798	2026-04-11 08:12:07.676652	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
405	9	Silver Ajit Kada For Him	https://giva.co/products/silver-ajit-kada-for-him	11799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLBR0101_1.jpg?v=1765458310	0	2026-04-11 08:12:07.663109	2026-04-11 08:12:07.676649	2026-04-11 08:12:07.676649	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
406	9	Rose Gold Endless Shenanigans Cuff Bracelet	https://giva.co/products/rose-gold-endless-shenanigans-cuff-bracelet	4099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01290_1.jpg?v=1745497708	0	2026-04-11 08:12:07.663554	2026-04-11 08:12:07.676649	2026-04-11 08:12:07.676649	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
407	9	Golden Woven Circle Stud For Him	https://giva.co/products/golden-woven-circle-stud-for-him	899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER0126_1_bce91961-38ad-4965-a010-1b6a2a90ac47.jpg?v=1770903445	0	2026-04-11 08:12:07.66474	2026-04-11 08:12:07.676649	2026-04-11 08:12:07.67665	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
408	9	Silver Joy Of Raindrops Earrings	https://giva.co/products/silver-joy-of-raindrops-earrings	2299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER01957_1-min.jpg?v=1681396035	0	2026-04-11 08:12:07.665189	2026-04-11 08:12:07.67665	2026-04-11 08:12:07.67665	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
409	9	Rose Gold Cross of Grace Earrings	https://giva.co/products/rose-gold-cross-of-grace-earrings	1499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02313_1_jpg.jpg?v=1700135412	0	2026-04-11 08:12:07.665658	2026-04-11 08:12:07.67665	2026-04-11 08:12:07.67665	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
411	9	Rose Gold Heart Wreath Set	https://giva.co/products/wreath-set	5399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/pd0572_er0583_1.jpg?v=1662715896	0	2026-04-11 08:12:07.666736	2026-04-11 08:12:07.676651	2026-04-11 08:12:07.676651	Set	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
412	9	Rose Gold Double Trouble Heart Pendant With Link Chain	https://giva.co/products/rose-gold-double-trouble-heart-pendant-with-link-chain	2999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0572_1.jpg?v=1643376278	0	2026-04-11 08:12:07.667345	2026-04-11 08:12:07.676651	2026-04-11 08:12:07.676652	Pendant	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
414	9	Silver Adore Love Earrings	https://giva.co/products/silver-adore-love-earrings	2699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02953_1.jpg?v=1736431946	0	2026-04-11 08:12:07.668416	2026-04-11 08:12:07.676652	2026-04-11 08:12:07.676652	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
415	9	Golden Rainbow Kids Studs	https://giva.co/products/golden-rainbow-kids-studs	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/KER042_1.jpg?v=1750346401	0	2026-04-11 08:12:07.668916	2026-04-11 08:12:07.676653	2026-04-11 08:12:07.676653	Kids Earring	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
423	9	Rose Gold Footprint Pendant With Link Chain	https://giva.co/products/rose-gold-footprint-pendant-with-link-chain	5199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD01913_1.jpg?v=1700739466	0	2026-04-11 08:12:07.67292	2026-04-11 08:12:07.676656	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
424	9	Silver 4Ever Pendant With Link Chain	https://giva.co/products/silver-4ever-pendant-with-link-chain	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLPD06_1.jpg?v=1764856887	0	2026-04-11 08:12:07.673284	2026-04-11 08:12:07.676656	2026-05-15 05:09:37.010697	Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
728	37	Ridge Wallet - Lone Wolf	https://ridge.com/products/lone-wolf	150	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/LoneWolf-Wallet-THUMBNAIL.jpg?v=1774631134	0	2026-04-21 10:23:23.006856	2026-04-16 10:29:16.976841	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	t	t	\N	0	0	culture	shopify	backfill
416	9	Golden Brahma Kamal Bud Necklace	https://giva.co/products/bhumi-golden-brahma-kamal-bud-necklace	9899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02272_1.jpg?v=1703766326	0	2026-04-11 08:12:07.669334	2026-04-11 08:12:07.676653	2026-04-11 08:12:07.676653	Pendant	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
417	9	Rose Gold Cascade Danglers	https://giva.co/products/rose-gold-cascade-danglers	4699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03203_1.jpg?v=1758807516	0	2026-04-11 08:12:07.669773	2026-04-11 08:12:07.676653	2026-04-11 08:12:07.676654	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
418	9	Silver Light It Up Necklace	https://giva.co/products/silver-light-it-up-necklace	11899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03158_5_fba657cd-1876-4b44-b15a-930a5c040c44.jpg?v=1767592437	0	2026-04-11 08:12:07.670379	2026-04-11 08:12:07.676654	2026-04-11 08:12:07.676654	Pendant	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
419	9	Silver Queen of The Night Dangler Earrings	https://giva.co/products/disco-ball-earring	1999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER0778_1.jpg?v=1648215377	0	2026-04-11 08:12:07.670925	2026-04-11 08:12:07.676654	2026-04-11 08:12:07.676654	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
420	9	Silver Solitaire Pearl Studs	https://giva.co/products/silver-solitaire-pearl-studs	3899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER0104_1.jpg?v=1627033927	0	2026-04-11 08:12:07.67151	2026-04-11 08:12:07.676655	2026-04-11 08:12:07.676655	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
421	9	Silver White Ice Stud For Him	https://giva.co/products/silver-white-ice-stud-for-him	1299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER070_1.jpg?v=1754564148	0	2026-04-11 08:12:07.672169	2026-04-11 08:12:07.676655	2026-04-11 08:12:07.676655	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
422	9	Silver Jadeite Stud For Men	https://giva.co/products/silver-jadeite-stud-for-men	699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER017_1.jpg?v=1742886793	0	2026-04-11 08:12:07.672598	2026-04-11 08:12:07.676655	2026-04-11 08:12:07.676656	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
425	9	Silver Chakra Shield Stud For Him	https://giva.co/products/silver-chakra-shield-stud-for-him	1499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER094_5.jpg?v=1758208036	0	2026-04-11 08:12:07.673645	2026-04-11 08:12:07.676657	2026-04-11 08:12:07.676657	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
426	9	Silver Black Swan Necklace	https://giva.co/products/silver-black-swan-necklace	3899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0110_1.jpg?v=1632896617	0	2026-04-11 08:12:07.673967	2026-04-11 08:12:07.676657	2026-04-11 08:12:07.676657	Pendant	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
671	29	Keychron Ultra-Fast Lime Magnetic Switch	https://keychron.com/products/keychron-ultra-fast-lime-magnetic-switch	29.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron_Magnetic_Switch-Ultra-fast_Lime_Banana-110pcs-2.jpg?v=1775182487	0	2026-05-14 07:21:29.224353	2026-04-16 10:29:10.034072	2026-05-15 05:09:37.010697	Switches	\N	t	t	\N	0	0	culture	shopify	backfill
796	36	Hand Wash Bottle	https://lastobject.com/products/hand-wash-bottle	5	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/Carousel_Hand_Wash_Bottle_1_2ea6a6a2-48a9-4073-a985-6695b1cb1c0b.jpg?v=1713852836	0	2026-05-14 07:20:40.124148	2026-04-16 10:29:20.122641	2026-05-15 05:09:37.010697	Powder Soaps	\N	t	t	\N	0	0	beauty	shopify	backfill
806	36	Laundry Bag	https://lastobject.com/products/laundry-bag	9	USD	https://cdn.shopify.com/s/files/1/0225/3393/1085/files/1_HeroEN.png?v=1694436754	0	2026-05-14 07:20:40.127543	2026-04-16 10:29:20.122647	2026-05-15 05:09:37.010697	New	\N	t	t	\N	0	0	beauty	shopify	backfill
352	5	75% Alcohol Wipe Pads	https://thekarelab.com/products/75-alcohol-wipe-pads-b2c	56	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/75-alcohol-wipe-pads-487935.png?v=1648453571	0	2026-05-14 07:20:27.772383	2026-04-11 06:27:34.217656	2026-05-14 07:20:27.777404	Health & Beauty	\N	f	\N	\N	0	0	beauty	shopify	m004|keyword_ma|80
914	27	Filter Card - Monochrome Elegance	https://papershoot.com/products/filter-card-monochrome-elegance	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Monochrome.png?v=1766570318	0	2026-05-14 07:20:29.405844	2026-04-16 10:29:29.298431	2026-05-14 07:20:29.415627	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1109	25	1 Year of Bathroom Cleaner	https://blueland.com/products/1-year-of-bathroom-cleaner	23	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/PLP_AnnualBundle_Bathroom_2026.jpg?v=1771444493	0	2026-05-07 03:05:05.452018	2026-04-21 11:26:58.611657	2026-05-07 03:05:05.452967	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
670	29	Keychron K3 HE Wireless Magnetic Switch Custom Keyboard	https://keychron.com/products/keychron-k3-he-wireless-magnetic-switch-custom-keyboard	119.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-K3-HE-Features.jpg?v=1774250330	0	2026-05-14 07:21:29.223964	2026-04-16 10:29:10.034072	2026-05-14 07:21:29.229551	Slim Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
729	37	Ridge Keychain - Whiskey Dark Brown Leather	https://ridge.com/products/ridge-keychain-whiskey-dark-brown-leather	35	USD	\N	0	2026-04-21 10:23:23.007491	2026-04-16 10:29:16.976841	2026-04-21 10:23:23.020595	EDC - Key Accessories - Ridge Keychain - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
977	23	Fertility Support Ritual*	https://ritual.com/products/fertility-support-ritual	138	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Essential_FertilitySupportforPrenatal.webp?v=1773186081	0	2026-05-14 07:21:14.104879	2026-04-16 10:29:45.85224	2026-05-15 05:09:37.010697	bundle	\N	t	t	\N	0	0	health	shopify	backfill
975	23	Daily Health 50+ Support Ritual*	https://ritual.com/products/daily-health-50-support-ritual	93	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Essential-_-Gut-Duo-for-Women-50.webp?v=1773185976	0	2026-05-14 07:21:14.103868	2026-04-16 10:29:45.852239	2026-05-14 07:21:14.115111	bundle	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
976	23	Daily Health 18+ Support Ritual*	https://ritual.com/products/daily-health-18-support-ritual	87	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Essential_GutDuo.webp?v=1773185920	0	2026-05-14 07:21:14.104419	2026-04-16 10:29:45.85224	2026-05-14 07:21:14.115111	bundle	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
457	15	Menopause Bundle	https://elixhealing.com/products/menopause-bundle	114	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/MenopauseTrio_transparent_ed8a9edc-336b-4a3d-b509-1b1b5c24a2b6.png?v=1773326104	0	2026-04-14 03:05:47.102143	2026-04-11 08:50:45.100931	2026-04-14 03:05:47.115282	ingredient: Ginger	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
460	15	Acu-Socks	https://elixhealing.com/products/socks	20	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/Acu-socks_Acupressure_Socks_2.jpg?v=1769030260	0	2026-04-21 10:23:09.198409	2026-04-11 08:50:45.100934	2026-04-21 10:23:09.235803	Elix	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
672	29	Keychron C0 HE One Handed Magnetic Switch Gaming Keyboard	https://keychron.com/products/keychron-c0-he-one-handed-magnetic-switch-gaming-keyboard	59.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-C0-HE-features.jpg?v=1773276861	0	2026-05-14 07:21:29.224719	2026-04-16 10:29:10.034073	2026-05-14 07:21:29.229552	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
673	29	Keychron V6 8K QMK Wired Custom Mechanical Keyboard	https://keychron.com/products/keychron-v6-8k-qmk-wired-custom-mechanical-keyboard	84.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-V6-8K-Features.jpg?v=1773116495	0	2026-05-14 07:21:29.225086	2026-04-16 10:29:10.034073	2026-05-14 07:21:29.229552	Wired Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
674	29	Keychron V5 8K QMK Wired Custom Mechanical Keyboard	https://keychron.com/products/keychron-v5-8k-qmk-wired-custom-mechanical-keyboard	84.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-V5-8K-Features.jpg?v=1773116507	0	2026-05-14 07:21:29.225465	2026-04-16 10:29:10.034074	2026-05-14 07:21:29.229552	Wired Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
675	29	Keychron V3 8K QMK Wired Custom Mechanical Keyboard	https://keychron.com/products/keychron-v3-8k-qmk-wired-custom-mechanical-keyboard	74.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-V3-8K-Features.jpg?v=1773105036	0	2026-05-14 07:21:29.225815	2026-04-16 10:29:10.034074	2026-05-14 07:21:29.229552	Wired Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
676	29	Keychron Q13 Ultra 8K Wireless Custom Mechanical Keyboard	https://keychron.com/products/keychron-q13-ultra-8k-wireless-custom-mechanical-keyboard	249.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-Q13-Ultra-8K-Features.jpg?v=1772688212	0	2026-05-14 07:21:29.226152	2026-04-16 10:29:10.034075	2026-05-14 07:21:29.229552	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
677	29	Keychron Q5 Ultra 8K Wireless Custom Mechanical Keyboard	https://keychron.com/products/keychron-q5-ultra-8k-wireless-custom-mechanical-keyboard	239.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Q5_Ultra-_features.jpg?v=1772618604	0	2026-05-14 07:21:29.226495	2026-04-16 10:29:10.034075	2026-05-14 07:21:29.229552	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
339	5	Antiviral, Antimicrobial Silver Push Door Plate	https://thekarelab.com/products/antiviral-antimicrobial-silver-push-door-plate	99	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/AclivPushPlate01.png?v=1681897895	0	2026-05-14 07:20:27.766348	2026-04-11 06:27:34.217646	2026-05-14 07:20:27.777401	Infection Prevention	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
979	23	Pregnancy & Microbiome‡ Support Ritual*	https://ritual.com/products/pregnancy-microbiome-support-ritual	128	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Essential_Natalbiotic_CholineTrioforPrenatal.webp?v=1773186462	0	2026-05-14 07:21:14.10536	2026-04-16 10:29:45.852241	2026-05-15 05:09:37.010697	bundle	\N	t	t	\N	0	0	health	shopify	backfill
678	29	Keychron Q5 HE 8K Magnetic Switch Keyboard	https://keychron.com/products/keychron-q5-he-8k-magnetic-switch-keyboard	239.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron_Q5_HE_8K__Keychron_Ultra-fast_Lime_Magnetic_Switch_Keyboard-1.jpg?v=1773626159	0	2026-05-14 07:21:29.22682	2026-04-16 10:29:10.034076	2026-05-14 07:21:29.229553	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
679	29	Keychron R5 QMK Wireless Mechanical Keyboard	https://keychron.com/products/keychron-r5-qmk-wireless-mechanical-keyboard	89.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron_R5QMKWirelessMechanicalKeyboard_red.jpg?v=1772249257	0	2026-05-14 07:21:29.227189	2026-04-16 10:29:10.034076	2026-05-14 07:21:29.229553	Custom Keyboards	\N	f	f	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
475	15	Cycle Balance Quarterly Double Dose	https://elixhealing.com/products/cycle-balance-quarterly-double-dose	208.8	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/ElixHealing_Bottle_CycleBalance_1_ea4d81f2-6001-4780-8fbe-c064a4a74faa.png?v=1715186605	0	2026-04-21 10:23:09.22144	2026-04-11 08:50:45.100944	2026-04-21 10:23:09.235806	Hidden	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
476	15	Cycle Balance Quarterly Double Dose	https://elixhealing.com/products/cycle-balance-quarterly-double-dose-copy	208.8	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/ElixHealing_Bottle_CycleBalance_1_ea4d81f2-6001-4780-8fbe-c064a4a74faa.png?v=1715186605	0	2026-04-21 10:23:09.222681	2026-04-11 08:50:45.100944	2026-04-21 10:23:09.235806	Hidden	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
477	15	Cycle Balance Quarterly Double Dose	https://elixhealing.com/products/cycle-balance-quarterly-dd	208.8	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/ElixHealing_Bottle_CycleBalance_1_ea4d81f2-6001-4780-8fbe-c064a4a74faa.png?v=1715186605	0	2026-04-21 10:23:09.224143	2026-04-11 08:50:45.100945	2026-04-21 10:23:09.235807	Hidden	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
478	15	Elix Teaspoon	https://elixhealing.com/products/elix-teaspoon	12	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/products/Teaspoonclearoption.png?v=1669931806	0	2026-04-21 10:23:09.225519	2026-04-11 08:50:45.100946	2026-04-21 10:23:09.235807	Elix	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1085	25	Dishwasher + Laundry Detergent Sample Pack (14 Tablets - 7 Each)	https://blueland.com/products/laundry-dishwasher-detergent-sample-pack-14-tablets	10	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Sample_Pack_Dish_and_Laundry_SB.jpg?v=1776380262	0	2026-05-14 07:20:29.690843	2026-04-21 11:26:58.611648	2026-05-14 07:20:29.705078	Samples	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1086	25	Hand Soap Tablet Refills	https://blueland.com/products/hand-soap-refill-packs	7.5	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_HSRefills__5pk_ClassiclVariety_Tablets_Final_2026_01.jpg?v=1775851860	0	2026-05-14 07:20:29.691561	2026-04-21 11:26:58.611648	2026-05-14 07:20:29.705079	Refills	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
919	27	Filter Card -Icy Chill	https://papershoot.com/products/filter-card-icy-chill	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/IcyChill.png?v=1766570318	0	2026-05-14 07:20:29.407895	2026-04-16 10:29:29.298433	2026-05-14 07:20:29.415628	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1087	25	Scrub Sponge	https://blueland.com/products/scrub-sponge	14	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Scrub_Sponge_Final_2026_01.jpg?v=1769797427	0	2026-05-14 07:20:29.692063	2026-04-21 11:26:58.611649	2026-05-14 07:20:29.705079	Extras	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
680	29	Keychron J2 HE 8K Magnetic Switch Keyboard	https://keychron.com/products/keychron-j2-he-8k-magnetic-switch-keyboard	99.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron_J2_HE_8K_Swappable_Ultra-Fast_Lime_Magnetic_Switches-Black.jpg?v=1772266222	0	2026-05-14 07:21:29.227543	2026-04-16 10:29:10.034077	2026-05-14 07:21:29.229553	Custom Keyboards	\N	f	f	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
1088	25	Laundry Detergent Starter Set	https://blueland.com/products/laundry-starter-set	25	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Laundry_Free_Clear_Starter_Set_Final_2026_01.jpg?v=1772732616	0	2026-05-14 07:20:29.692575	2026-04-21 11:26:58.611649	2026-05-14 07:20:29.705079	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
685	29	Keychron K2 HE Wireless Magnetic Switch Custom Keyboard - Concrete Edition	https://keychron.com/products/keychron-k2-he-wireless-magnetic-switch-custom-keyboard-concrete-edition	199.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/K2-HE-Concrete-Iconic-Features.jpg?v=1768874717	0	2026-04-21 10:23:40.00872	2026-04-16 10:29:10.034079	2026-04-21 10:23:40.014478	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
984	23	Women’s Multivitamin 50+	https://ritual.com/products/essential-multivitamin-for-women-over-50	39	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP_EFW50_Bottle.jpg?v=1770263110	0	2026-05-14 07:21:14.107477	2026-04-16 10:29:45.852244	2026-05-14 07:21:14.115113	50+	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
986	23	Men’s Multivitamin 50+	https://ritual.com/products/essential-multivitamin-for-men-over-50	39	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP_EFM50_Bottle.jpg?v=1770263114	0	2026-05-14 07:21:14.108397	2026-04-16 10:29:45.852245	2026-05-14 07:21:14.115113	50+	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
125	7	Frayed Linen Table Napkins | Rosé	https://coreyashford.com/products/frayed-linen-table-napkins-rose	27.5	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-linen-napkin-set-of-2-rose-pink.jpg?v=1764223093	0	2026-04-21 10:23:11.196893	2026-04-10 10:19:59.560138	2026-04-21 10:23:11.215679	__tab1:details-linen-napkins	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
126	7	Frayed Linen Placemat Pair | Rosé	https://coreyashford.com/products/frayed-linen-placemats-rose	32.5	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-linen-placemat-set-of-2-rose-pink.jpg?v=1764223111	0	2026-04-21 10:23:11.198145	2026-04-10 10:19:59.560138	2026-04-21 10:23:11.215679	Linen	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
130	7	Oyster Keyring | Gold	https://coreyashford.com/products/oyster-keyring-gold	89	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/crey-ashford-oyster-keyring.jpg?v=1760390868	0	2026-04-21 10:23:11.201672	2026-04-10 10:19:59.560141	2026-04-21 10:23:11.21568	lifestyle	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
131	7	Oyster Keyring | Silver	https://coreyashford.com/products/oyster-keyring-silver	89	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/silver-oyster-keyring.jpg?v=1760391185	0	2026-04-21 10:23:11.202358	2026-04-10 10:19:59.560141	2026-04-21 10:23:11.21568	lifestyle	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
132	7	Martini Glasses | Set of 2	https://coreyashford.com/products/martini-glasses-pair	250	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/martini-glass.jpg?v=1760391735	0	2026-04-21 10:23:11.203035	2026-04-10 10:19:59.560141	2026-04-21 10:23:11.21568	Glassware	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
133	7	Olive Cocktail Picks | Set of 4	https://coreyashford.com/products/olive-cocktail-pick-stainless-steel	135	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-olive-cocktail-pick-silver.jpg?v=1760343520	0	2026-04-21 10:23:11.203796	2026-04-10 10:19:59.560142	2026-04-21 10:23:11.215681	COREY ASHFORD	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
135	7	Scallop Incense Holder | Silver	https://coreyashford.com/products/scallop-incense-holder-silver	115	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey_ashford_silver_scallop_incense_holder_8cc2e6cb-3846-4675-bbd4-a4af49a600f4.jpg?v=1737595246	0	2026-04-21 10:23:11.205303	2026-04-10 10:19:59.560143	2026-04-21 10:23:11.215681	lifestyle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
136	7	Scallop Incense Holder | Brass	https://coreyashford.com/products/scallop-incense-holder-brass	95	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey_ashford_brass_scallop_incense_holder_dd88097a-72cc-4f61-a951-d235dc2d43fc.jpg?v=1737595017	0	2026-04-21 10:23:11.20594	2026-04-10 10:19:59.560143	2026-04-21 10:23:11.215681	lifestyle	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
137	7	Croissant Napkin Rings | Set of 2	https://coreyashford.com/products/croissant-napkin-rings	110	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-gold-brass-croissant-napkin-ring.jpg?v=1737595701	0	2026-04-21 10:23:11.206735	2026-04-10 10:19:59.560144	2026-04-21 10:23:11.215682	lifestyle	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
138	7	Atlas Incense Dish | Marble	https://coreyashford.com/products/atlas-incense-holder-marble	120	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/COREY_ASHFORD_ATLAS_INCENSE_DISH_MARBLE.jpg?v=1737522445	0	2026-04-21 10:23:11.207406	2026-04-10 10:19:59.560144	2026-04-21 10:23:11.215682	lifestyle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
636	21	Canvas Lug Tote | Trench Coat Khaki	https://everlane.com/products/womens-lug-large-canvas-tote-bag-trench-coat-khaki	228	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/922a48c2_6e55.jpg?v=1768939209	0	2026-05-14 07:21:14.126928	2026-04-16 10:29:07.014613	2026-05-14 07:21:14.132529	Bags	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
121	7	Athena Calderone: Live Beautiful	https://coreyashford.com/products/athena-calderone-live-beautiful	65	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/Lie-Beauitful.jpg?v=1773214434	0	2026-04-21 10:23:11.190455	2026-04-10 10:19:59.560135	2026-04-21 10:23:11.215677	Book	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
122	7	Ellie Bouhadana: Ellie's Table	https://coreyashford.com/products/ellie-bouhadana-ellies-table	55	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/Ellie_s-Table.jpg?v=1773214004	0	2026-04-21 10:23:11.192799	2026-04-10 10:19:59.560136	2026-04-21 10:23:11.215678	lifestyle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
123	7	Letitia Clark: Wild Figs & Fennel	https://coreyashford.com/products/wild-figs-fennel	55	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/wild-figs-and-fennel.jpg?v=1773213904	0	2026-04-21 10:23:11.194071	2026-04-10 10:19:59.560137	2026-04-21 10:23:11.215678	Book	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
124	7	Arent & Pyke: Interiors Beyond the Primary Palette	https://coreyashford.com/products/arent-pyke-interiors-beyond-the-primary-palette	80	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/arent-and-pyke.jpg?v=1773213841	0	2026-04-21 10:23:11.195823	2026-04-10 10:19:59.560137	2026-04-21 10:23:11.215678	Book	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
493	16	The Stanley 1913 x Nelly Korda All Day Julienne Mini Cooler	https://stanley1913.com/products/stanley-1913-x-nelly-korda-all-day-julienne-mini-cooler	120	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-The_All_Day_Julienne_Mini_Cooler_7.4QT_-_Nelly_Korda_Pinstripe_-_Front.png?v=1775147569	0	2026-05-07 03:04:43.797495	2026-04-11 08:53:26.44475	2026-05-07 03:04:43.807647	normal	\N	t	f	2026-04-21 10:23:17.579601	0	0	\N	shopify	m004|uncategori|0
169	8	Pink Cobaltian Calcite Stone	https://energymuse.com/products/pink-cobaltian-calcite-stone	18.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/PinkCobaltianCalciteStone.png?v=1774393866	0	2026-04-14 03:05:56.456442	2026-04-10 10:30:59.100383	2026-04-14 03:05:56.458394	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
170	8	Dioptase in Matrix Stone	https://energymuse.com/products/dioptase-in-matrix-stone	19.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/DioptaseinMatrixStone.png?v=1774393726	0	2026-04-14 03:05:56.456859	2026-04-10 10:30:59.100383	2026-04-14 03:05:56.458395	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
171	8	Svetyalite Stone	https://energymuse.com/products/svetyalite-stone	6.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/SvetyaliteStone.png?v=1774393593	0	2026-04-14 03:05:56.45724	2026-04-10 10:30:59.100384	2026-04-14 03:05:56.458395	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
172	8	Wernerite (Scapolite) Stone	https://energymuse.com/products/wernerite-scapolite-stone	19.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/WerneriteStone.png?v=1774393452	0	2026-04-14 03:05:56.457637	2026-04-10 10:30:59.100384	2026-04-14 03:05:56.458395	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
494	16	The Stanley 1913 x Nelly Korda Legendary Useful Box	https://stanley1913.com/products/stanley-1913-x-nelly-korda-legendary-useful-box	40	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-The_Legendary_Useful_Box_1.25QT_-_Nelly_Korda_Pinstripe_-_Front.png?v=1775147242	0	2026-05-07 03:04:43.798129	2026-04-11 08:53:26.444751	2026-05-07 03:04:43.807647	normal	\N	t	f	2026-04-21 10:23:17.58026	0	0	\N	shopify	m004|uncategori|0
340	5	Antiviral, antimicrobial Surface Adhesive Protection Film 60MIC Clear & Matt	https://thekarelab.com/products/antivirus-surface-adhesive-protection-film-60mic-clear-matt	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/antivirus-surface-adhesive-protection-film-60mic-clear-matt-822269.png?v=1663940631	0	2026-05-14 07:20:27.766852	2026-04-11 06:27:34.217647	2026-05-14 07:20:27.777401	Infection Prevention	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
499	16	The Quencher® ProTour Flip Straw Tumbler	https://stanley1913.com/products/quencher-protour-flip-straw-tumbler-20-oz-picnic	45	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherProTourFlipStrawTumbler20OZ-RoseQuartzRattan-Front.png?v=1775097212	0	2026-05-07 03:04:43.801162	2026-04-11 08:53:26.444755	2026-05-07 03:04:43.807649	Protour 20oz	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
500	16	The Everyday Slim Can Cooler Cup	https://stanley1913.com/products/everyday-slim-can-cooler-cup-10-oz-picnic	35	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-02-06__The_Everyday_Slim_Can_Cooler_Cup_10OZ_-_Rose_Quartz_Rattan_-_Front.png?v=1775096796	0	2026-05-07 03:04:43.80179	2026-04-11 08:53:26.444756	2026-05-07 03:04:43.807649	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1104	25	1 Year of Glass + Mirror Cleaner	https://blueland.com/products/1-year-of-glass-mirror	23	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/PLP_AnnualBundle_Glass_Mirror_2026.jpg?v=1771444414	0	2026-05-14 07:20:29.702015	2026-04-21 11:26:58.611655	2026-05-14 07:20:29.705083	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
688	29	Keychron K4 Max QMK Wireless Mechanical Keyboard ISO Layout Collection	https://keychron.com/products/keychron-k4-max-qmk-wireless-mechanical-keyboard-iso-layout-collection	119.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron_K4_Max_QMK_Wireless_Custom_Mechanical_Keyboard_-1.png?v=1769582984	0	2026-04-16 10:29:10.033214	2026-04-16 10:29:10.03408	2026-04-16 10:29:10.03408	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
1105	25	Forever Tin	https://blueland.com/products/the-forever-tin	10	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/PLP_DTC_Tins_Sea_Salt_Final_2026.jpg?v=1770670960	0	2026-05-14 07:20:29.702457	2026-04-21 11:26:58.611656	2026-05-14 07:20:29.705083	Extras	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
637	21	Canvas Lug Tote | Black	https://everlane.com/products/womens-lug-large-canvas-tote-bag-black	228	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/c902cf80_87a3.jpg?v=1773414004	0	2026-05-14 07:21:14.127259	2026-04-16 10:29:07.014613	2026-05-14 07:21:14.132529	Bags	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
1219	21	The ReNew Transit Backpack | Estate Blue	https://everlane.com/products/mens-renew-backpack-estate-blue	118	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/ee241e7a_fa68.jpg?v=1774371603	0	2026-05-14 07:21:14.12123	2026-05-14 07:21:14.134013	2026-05-14 07:21:14.134014	Bags	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1220	21	The ReNew Transit Backpack | Estate Blue	https://everlane.com/products/womens-renew-backpack-estate-blue	118	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/ee241e7a_db3b.jpg?v=1774371602	0	2026-05-14 07:21:14.122522	2026-05-14 07:21:14.134014	2026-05-14 07:21:14.134014	Bags	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
693	33	Offer - CurrentBody Skin Green Tea Serum	https://currentbody.com/products/currentbody-skin-green-tea-serum-offer	45.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Currentbody_skin_green_tea_serum.png?v=1766487913	0	2026-05-07 03:05:41.817182	2026-04-16 10:29:11.565064	2026-05-07 03:05:41.840936	Skincare	\N	t	t	\N	0	0	beauty	shopify	m004|keyword_ma|80
334	5	KORE Manuka MGO514+ (250g)	https://thekarelab.com/products/kore-manuka-mgo514-250g	728	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo514-250g-438870.png?v=1668526707	0	2026-05-14 07:20:27.76271	2026-04-11 06:27:34.217642	2026-05-14 07:20:27.7774	b2c_product	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
335	5	KORE Manuka MGO829+ (250g)	https://thekarelab.com/products/kore-manuka-mgo829-250g	1288	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo829-250g-946525.png?v=1668526705	0	2026-05-14 07:20:27.763345	2026-04-11 06:27:34.217643	2026-05-14 07:20:27.7774	b2c_product	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
336	5	Antiviral, Antimicrobial Silver Pull Door Wrap Small	https://thekarelab.com/products/copy-of-antiviral-antimicrobial-pull-door-wrap-small	45	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/antiviral-antimicrobial-pull-door-wrap-small-225019.png?v=1681923361	0	2026-05-14 07:20:27.763944	2026-04-11 06:27:34.217644	2026-05-14 07:20:27.7774	Infection Prevention	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
337	5	Antiviral, Antimicrobial Silver Button	https://thekarelab.com/products/antiviral-antimicrobial-silver-button	42	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/antiviral-antimicrobial-silver-button-139844.png?v=1681923362	0	2026-05-14 07:20:27.765093	2026-04-11 06:27:34.217644	2026-05-14 07:20:27.7774	Infection Prevention	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
338	5	Antiviral, Antimicrobial Silver Pull Door Wrap Large	https://thekarelab.com/products/antiviral-antimicrobial-pull-door-wrap	69	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/AclivPullDoorHandleWrap01.png?v=1681897843	0	2026-05-14 07:20:27.765821	2026-04-11 06:27:34.217645	2026-05-14 07:20:27.777401	b2c_product	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
941	27	Effect Lens Duo	https://papershoot.com/products/effect-lens-duo	21.8	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Wideangle_MacroLens.png?v=1763981481	0	2026-05-14 07:20:29.415029	2026-04-16 10:29:29.298443	2026-05-14 07:20:29.415632	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
915	27	Filter Card - Moody	https://papershoot.com/products/filter-card-moody	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Moody.png?v=1766570318	0	2026-05-14 07:20:29.40635	2026-04-16 10:29:29.298432	2026-05-14 07:20:29.415627	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
916	27	Filter Card - Dynamic	https://papershoot.com/products/filter-card-dynamic	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Dynamic.png?v=1766570318	0	2026-05-14 07:20:29.406796	2026-04-16 10:29:29.298432	2026-05-14 07:20:29.415627	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
917	27	Filter Card -Violet Haze	https://papershoot.com/products/filter-card-violet-haze	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/ViolerHaze.png?v=1766570318	0	2026-05-14 07:20:29.407179	2026-04-16 10:29:29.298432	2026-05-14 07:20:29.415627	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
918	27	Filter Card -Teal & Orange	https://papershoot.com/products/filter-card-teal-orange	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/teal_Orange.png?v=1766570318	0	2026-05-14 07:20:29.407544	2026-04-16 10:29:29.298433	2026-05-14 07:20:29.415628	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
144	7	Slim Lighter | Brass	https://coreyashford.com/products/slim-lighter-brass	65	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-gold-slim-lighter.jpg?v=1737596050	0	2026-04-21 10:23:11.211156	2026-04-10 10:19:59.560147	2026-04-21 10:23:11.215683	lifestyle	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
145	7	Madeleine Box | Brass	https://coreyashford.com/products/madeleine-box-brass	125	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-brass-madeleine-box-trinket-jar.jpg?v=1737523246	0	2026-04-21 10:23:11.211724	2026-04-10 10:19:59.560148	2026-04-21 10:23:11.215684	lifestyle	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
146	7	Madeleine Box | Marble	https://coreyashford.com/products/madeleine-box-marble	225	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-marble-madeleine-box-trinket-jar_80dab49b-59a3-4a47-a44c-6560de0aa4dd.jpg?v=1737523258	0	2026-04-21 10:23:11.212346	2026-04-10 10:19:59.560148	2026-04-21 10:23:11.215684	lifestyle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
147	7	Incense | The Garden	https://coreyashford.com/products/incense-the-garden	45	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-japanese-incense-the-garden-2.jpg?v=1737693742	0	2026-04-21 10:23:11.212995	2026-04-10 10:19:59.560149	2026-04-21 10:23:11.215684	Incense	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
148	7	Incense | A Café in Paris	https://coreyashford.com/products/incense-a-cafe-in-paris	45	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-japanese-incense-cafe-in-paris-coffee-tobacco.jpg?v=1737691816	0	2026-04-21 10:23:11.213555	2026-04-10 10:19:59.560149	2026-04-21 10:23:11.215684	Incense	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
149	7	Frayed Linen Placemats | Set of 2	https://coreyashford.com/products/frayed-linen-placemats	69	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-european-frayed-linen-napkins-grey-driftwood_09ff322e-39b0-4329-973b-a57d61bdb2e6.jpg?v=1717811462	0	2026-04-21 10:23:11.214085	2026-04-10 10:19:59.56015	2026-04-21 10:23:11.215684	Linen	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
920	27	Filter Card -Classic Film	https://papershoot.com/products/filter-card-classic-film	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/classic_07fb1327-cdab-464c-8cba-55693c220f6f.png?v=1766570318	0	2026-05-14 07:20:29.408222	2026-04-16 10:29:29.298434	2026-05-14 07:20:29.415628	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
501	16	The All Day Julienne Mini Cooler	https://stanley1913.com/products/all-day-julienne-mini-cooler-picnic	110	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-02-09__The_All-Day_Julienne_Mini_Cooler_7.4QT_-_Rose_Quartz_Rattan_-_Front.png?v=1775096268	0	2026-05-07 03:04:43.802445	2026-04-11 08:53:26.444757	2026-05-07 03:04:43.80765	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
922	27	Filter Card -Limewave	https://papershoot.com/products/filter-card-limewave	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/limewave.png?v=1766570318	0	2026-05-14 07:20:29.408918	2026-04-16 10:29:29.298435	2026-05-14 07:20:29.415628	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
502	16	The All Day Madeleine Mini Cooler Backpack	https://stanley1913.com/products/all-day-madeleine-mini-cooler-backpack-picnic	135	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-02-09_TheAllDayMadeleineMiniCoolerBackpack14QT-PeachRosePicnicStripe-Front.png?v=1774558259	0	2026-05-07 03:04:43.803045	2026-04-11 08:53:26.444757	2026-05-07 03:04:43.80765	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
503	16	The Café-To-Go Travel Mug	https://stanley1913.com/products/cafe-to-go-travel-mug-12-oz-picnic	32	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheCafe-To-GoTravelMug12OZ-PeachRosePicnicStripe-Front.png?v=1774558255	0	2026-05-07 03:04:43.80365	2026-04-11 08:53:26.444758	2026-05-07 03:04:43.80765	Normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
504	16	The Quencher® ProTour Flip Straw Tumbler	https://stanley1913.com/products/quencher-protour-flip-straw-tumbler-40-oz-picnic	55	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherProTourFlipStrawTumbler40OZ-RoseQuartzRattan-Front.png?v=1774558253	0	2026-05-07 03:04:43.804222	2026-04-11 08:53:26.444759	2026-05-07 03:04:43.80765	Protour	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
505	16	The Quencher® ProTour Flip Straw Tumbler	https://stanley1913.com/products/quencher-protour-flip-straw-tumbler-30-oz-picnic	50	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherProTourFlipStrawTumbler30OZ-RoseQuartzRattan-Front.png?v=1774558251	0	2026-05-07 03:04:43.804907	2026-04-11 08:53:26.44476	2026-05-07 03:04:43.807651	Protour 30oz	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1171	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/the-quencher-h2-0-flowstate™-tumbler-vault	45	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.OFlowStateTumbler40OZ-Lemonade-Front.png?v=1776459176	0	2026-05-07 03:04:43.780555	2026-05-07 03:04:43.812644	2026-05-07 03:04:43.812645	Quencher 40oz	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1172	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/the-quencher-h2-0-flowstate™-tumbler-vault-1	40	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.OFlowStateTumbler30OZ-BlueberryMilk-Front.png?v=1775839939	0	2026-05-07 03:04:43.784252	2026-05-07 03:04:43.812646	2026-05-07 03:04:43.812646	Quencher 30oz	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1173	16	All Day Slim Bottle	https://stanley1913.com/products/the-all-day-slim-bottle-34-oz	40	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheAllDaySlimBottle34OZ-BlackGloss-Front.png?v=1762182135	0	2026-05-07 03:04:43.785935	2026-05-07 03:04:43.812647	2026-05-07 03:04:43.812647	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1221	21	Maxi Dress in Silk Georgette | Soft Floral	https://everlane.com/products/womens-maxi-dress-in-silk-georgette-soft-floral	348	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/fc324db9_63c1.jpg?v=1772578807	0	2026-05-14 07:21:14.123485	2026-05-14 07:21:14.134015	2026-05-14 07:21:14.134015	Dresses	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
288	6	Botanical Rose Coconut Candle	https://coconutbowls.com/products/botanical-rose-coconut-candle	22.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/11_04512bae-6553-403f-9d95-ea8431586501.png?v=1707188240	0	2026-04-21 10:23:12.022095	2026-04-11 06:01:47.027802	2026-04-21 10:23:12.031212	Candle	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
289	6	Coconut Lime Candles	https://coconutbowls.com/products/coconut-lime-coconut-soy-candles	22.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/1_0dc7733a-dea1-4c3f-9806-4a4766ad9abb.png?v=1637726020	0	2026-04-21 10:23:12.022691	2026-04-11 06:01:47.027802	2026-04-21 10:23:12.031212	Candle	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
290	6	Jumbo Family Pack	https://coconutbowls.com/products/jumbo-family-pack	67.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/image_SxW.jpg?v=1708315820	0	2026-04-21 10:23:12.02327	2026-04-11 06:01:47.027803	2026-04-21 10:23:12.031222	Bundle	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
1222	21	Relaxed Mid-Rise Bootcut Jean | Light Vintage Indigo	https://everlane.com/products/womens-relaxed-mid-rise-bootcut-jean-light-vintage-indigo	148	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/039ad6f9_5568.jpg?v=1772578804	0	2026-05-14 07:21:14.123869	2026-05-14 07:21:14.134015	2026-05-14 07:21:14.134015	Denim	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
492	16	The Quencher® ProTour Flip Straw Tumbler	https://stanley1913.com/products/quencher-protour-flip-straw-tumbler-40-oz-mothers-day	55	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-01-16_TheQuencherProTourFlipStrawTumbler40OZ-WildBlossoms-Front.png?v=1775504563	0	2026-05-07 03:04:43.796745	2026-04-11 08:53:26.44475	2026-05-07 03:04:43.807647	Protour	\N	t	f	2026-04-16 10:38:15.118867	0	0	\N	shopify	m004|uncategori|0
356	5	N95 Harley Commodity	https://thekarelab.com/products/harley-n95-masks-harley-commodity-particulate-respirator	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/n95-harley-commodity-650764.png?v=1613322469	0	2026-05-14 07:20:27.774134	2026-04-11 06:27:34.217659	2026-05-14 07:20:27.777405	Medical Masks	\N	f	\N	\N	0	0	health	shopify	m004|keyword_ma|80
357	5	N95 particulate respirators	https://thekarelab.com/products/n95-particulate-respirator	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/n95-particulate-respirators-343764.png?v=1613322475	0	2026-05-14 07:20:27.774599	2026-04-11 06:27:34.21766	2026-05-14 07:20:27.777405	Medical Masks	\N	f	\N	\N	0	0	health	shopify	m004|keyword_ma|80
358	5	Travel Essential Protect Kit	https://thekarelab.com/products/travel-essential-protect-kit	250	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/travel-essential-protect-kit-379848.png?v=1651438576	0	2026-05-14 07:20:27.775033	2026-04-11 06:27:34.21766	2026-05-14 07:20:27.777406	Health Care	\N	t	\N	\N	0	0	health	shopify	m004|keyword_ma|80
359	5	3M - model 1860	https://thekarelab.com/products/3m-n95-masks-model-1860	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/3m-model-1860-204321.png?v=1613322468	0	2026-05-14 07:20:27.775513	2026-04-11 06:27:34.217661	2026-05-14 07:20:27.777406	Medical Masks	\N	f	\N	\N	0	0	health	shopify	m004|keyword_ma|80
360	5	Oxygen Concentrator 5L & 10L	https://thekarelab.com/products/oxygen-concentrator	0	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/oxygen-concentrator-5l-10l-258420.png?v=1626693287	0	2026-05-14 07:20:27.77597	2026-04-11 06:27:34.217662	2026-05-14 07:20:27.777406	Oxygen Tanks	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
848	32	Napa Valley Reed Diffuser	https://hotellobbycandle.com/products/napa-valley-reed-diffuser	74	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/NapaValleyDiffuser-Regular.png?v=1757084899	0	2026-05-07 03:04:53.593134	2026-04-16 10:29:26.176078	2026-05-07 03:04:53.596463	Diffuser	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
553	9	Silver Remarkable Earrings	https://giva.co/products/silver-remarkable-earrings	4799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02820_1.jpg?v=1741268986	0	2026-04-13 10:51:18.906085	2026-04-13 10:51:18.9326	2026-04-13 10:51:18.9326	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
555	9	Anushka Sharma Silver Zircon Leaf Ring	https://giva.co/products/silver-zircon-leaf-ring	1299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R016_1.jpg?v=1711630948	0	2026-04-13 10:51:18.908942	2026-04-13 10:51:18.932601	2026-04-13 10:51:18.932601	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
849	32	New York Collection	https://hotellobbycandle.com/products/new-york-collection	199	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/New_York_Collection__Regular-_catalog.png?v=1756319461	0	2026-05-07 03:04:53.593647	2026-04-16 10:29:26.176078	2026-05-07 03:04:53.596463	Bundle	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
558	9	Silver Small Heart Drop Earrings	https://giva.co/products/silver-tiny-heart-drop-earrings	1399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0138_1.jpg?v=1756358689	0	2026-04-21 10:23:10.974927	2026-04-13 10:51:18.932603	2026-04-21 10:23:10.983129	Earrings	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
850	32	City Diffuser Collection	https://hotellobbycandle.com/products/city-diffuser-collection	296	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/CityCollection_Diffusers_Regular-catalog.png?v=1756319075	0	2026-05-07 03:04:53.594086	2026-04-16 10:29:26.176079	2026-05-07 03:04:53.596463	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
851	32	Core Diffusers Collection	https://hotellobbycandle.com/products/core-diffusers-collection	237	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/CoreCollection_Diffusers_Regular-catalog.png?v=1756316022	0	2026-05-07 03:04:53.594621	2026-04-16 10:29:26.17608	2026-05-07 03:04:53.596464	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
564	9	Silver Bathinda White Necklace	https://giva.co/products/silver-bathinda-white-necklace	14599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03389_1.jpg?v=1770874201	0	2026-04-13 10:51:18.919186	2026-04-13 10:51:18.932607	2026-04-13 10:51:18.932607	Necklace	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
565	9	Silver Studded Wave Necklace	https://giva.co/products/silver-studded-wave-necklace	7799	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLPD0124_1.jpg?v=1773318468	0	2026-04-13 10:51:18.919934	2026-04-13 10:51:18.932607	2026-04-13 10:51:18.932607	Trende Pendant	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
467	15	Giftcard test	https://elixhealing.com/products/giftcard-test	25	USD	\N	0	2026-04-21 10:23:09.211664	2026-04-11 08:50:45.100939	2026-04-21 10:23:09.235804	Elix	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1174	16	The Flowstate™ Spring Bottle	https://stanley1913.com/products/flowstate-spring-bottle-20-oz	30	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheFlowstateSpringBottle20oz-Black2.0-Front.png?v=1775572782	0	2026-05-07 03:04:43.787152	2026-05-07 03:04:43.812647	2026-05-07 03:04:43.812647	Water Bottles	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1175	16	Stanley 1913 x Paris Saint-Germain IceFlow™ Flip Straw 2.0 Jug	https://stanley1913.com/products/stanley-1913-x-paris-saint-germain-iceflow™-flip-straw-jug	70	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheIceFlowFlipStraw2.0Jug64OZ-PSGNouveau-Back.png?v=1775833922	0	2026-05-07 03:04:43.788227	2026-05-07 03:04:43.812648	2026-05-07 03:04:43.812648	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
570	9	Silver Bikaner Crest Necklace	https://giva.co/products/silver-bikaner-crest-necklace	25499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD03382_1.jpg?v=1770874894	0	2026-04-13 10:51:18.923527	2026-04-13 10:51:18.93261	2026-04-13 10:51:18.932611	Necklace	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
571	9	Silver Charming Oval Necklace	https://giva.co/products/silver-charming-oval-necklace	7699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLPD0127_1.jpg?v=1773319684	0	2026-04-13 10:51:18.924231	2026-04-13 10:51:18.932611	2026-04-13 10:51:18.932612	Trende Pendant	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
572	9	Silver Heartline Drift Earrings	https://giva.co/products/silver-heartline-drift-earrings	5599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03324_1.jpg?v=1769259313	0	2026-04-13 10:51:18.924938	2026-04-13 10:51:18.932612	2026-04-13 10:51:18.932612	Earrings	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
573	9	Silver Cherry Prunus Necklace	https://giva.co/products/silver-cherry-prunus-necklace	13699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD01820_1-min.jpg?v=1675494555	0	2026-04-13 10:51:18.925642	2026-04-13 10:51:18.932613	2026-04-13 10:51:18.932613	Pendant	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
574	9	Rose Gold Three Graces Lab Grown Diamond Earrings	https://giva.co/products/rose-gold-three-graces-lab-grown-diamond-earrings	30819.85	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDLER01171_1.jpg?v=1759326107	0	2026-04-13 10:51:18.926355	2026-04-13 10:51:18.932613	2026-04-13 10:51:18.932614	Gold Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
576	9	Gold Petal Bloom Lab Grown Diamond Studs	https://giva.co/products/gold-petal-bloom-diamond-studs	65548.38	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDLER0649_1.jpg?v=1750944102	0	2026-04-13 10:51:18.927597	2026-04-13 10:51:18.932615	2026-04-13 10:51:18.932615	Gold Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
579	9	Rose Gold Dream Tower Teardrop Earrings	https://giva.co/products/rose-gold-dream-tower-teardrop-earrings	5399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02134_1.jpg?v=1696511111	0	2026-04-13 10:51:18.929507	2026-04-13 10:51:18.932616	2026-04-13 10:51:18.932617	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
580	9	Golden Beads of Love Earrings	https://giva.co/products/gold-simple-studs	2999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER01304_1_0.jpg?v=1656584430	0	2026-04-13 10:51:18.930115	2026-04-13 10:51:18.932617	2026-04-13 10:51:18.932618	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1110	21	Mirrored Logo Tee | Heather Grey	https://everlane.com/products/womens-mirrored-logo-tee-heather-grey	58	USD	\N	0	2026-04-22 04:48:53.426199	2026-04-22 04:18:56.731452	2026-04-22 04:48:53.441199	algolia-ignore	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
1176	16	Stanley 1913 x Paris Saint-Germain Transit Flip Top Mug 2.0	https://stanley1913.com/products/stanley-1913-x-paris-saint-germain-transit-flip-top-mug-2-0	30	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheTransitFlipTopMug12OZ-PSGNouveau-Front.png?v=1775833920	0	2026-05-07 03:04:43.789479	2026-05-07 03:04:43.812648	2026-05-07 03:04:43.812649	Transit Flip Top Mug	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1177	16	Stanley 1913 x Paris Saint-Germain IceFlow™ Flip Straw Tumbler	https://stanley1913.com/products/the-iceflow™-flip-straw-2-0-tumbler	45	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheIceFlowFlipStraw2.0Tumbler30OZ-PSGNouveau-Front.png?v=1775833917	0	2026-05-07 03:04:43.790784	2026-05-07 03:04:43.812649	2026-05-07 03:04:43.812649	Iceflow FlipStraw	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1178	16	Stanley 1913 x Paris Saint-Germain Quencher® ProTour Flip Straw Tumbler	https://stanley1913.com/products/the-quencher®-protour-flip-straw-tumbler	40	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-_The_Quencher_ProTour_Flip_Straw_Tumbler_20OZ_-_PSG_Nouveau_-_Back_14eea181-671a-435a-8876-6cf274487d46.png?v=1775833915	0	2026-05-07 03:04:43.791893	2026-05-07 03:04:43.81265	2026-05-07 03:04:43.81265	Protour 20oz	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
808	35	Eating at Home Cookbook	https://golde.co/products/eating-at-home	33	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/COVEREatingatHome.jpg?v=1776170866	0	2026-05-07 03:04:53.774105	2026-04-16 10:29:21.767975	2026-05-07 03:04:53.783181	Golde 	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
809	35	Digital Gift Card	https://golde.co/products/gift-card	25	USD	https://cdn.shopify.com/s/files/1/1217/2268/products/giftcard.png?v=1607698521	0	2026-05-07 03:04:53.775125	2026-04-16 10:29:21.767976	2026-05-07 03:04:53.783182	Gift Cards	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
810	35	Kyoto Hojicha	https://golde.co/products/kyoto-hojicha	56	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/IKH09119_round2.jpg?v=1769273025	0	2026-05-07 03:04:53.775829	2026-04-16 10:29:21.767977	2026-05-07 03:04:53.783182	Golde 	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
811	35	Superwhisk + Original Turmeric Kit	https://golde.co/products/superwhisk-original-turmeric-kit	73	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/Superwhisk_OG_21687f1c-2955-44f2-abcb-322a10afbbe3.jpg?v=1724104732	0	2026-05-07 03:04:53.776445	2026-04-16 10:29:21.767977	2026-05-07 03:04:53.783182	beautyandother	\N	t	t	\N	0	0	beauty	shopify	m004|keyword_ma|80
812	35	Superwhisk + Matcha Kit	https://golde.co/products/superwhisk-matcha-kit	80	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/Superwhisk_PM40.png?v=1723823759	0	2026-05-07 03:04:53.776984	2026-04-16 10:29:21.767978	2026-05-07 03:04:53.783183	beautyandother	\N	t	t	\N	0	0	beauty	shopify	m004|keyword_ma|80
813	35	Shroom Shield	https://golde.co/products/new-shroom-shield	32	USD	https://cdn.shopify.com/s/files/1/1217/2268/products/ShroomShield15s_Front_IKH06498.jpg?v=1677012859	0	2026-05-07 03:04:53.777482	2026-04-16 10:29:21.767978	2026-05-07 03:04:53.783183	food	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
814	35	Collagen Boost	https://golde.co/products/new-coconut-collagen-boost	18	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/CollagenBoost30_front_IKH06993.jpg?v=1696598505	0	2026-05-07 03:04:53.77806	2026-04-16 10:29:21.767979	2026-05-07 03:04:53.783183	food	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
815	35	Collagen Boost + Matcha Kit	https://golde.co/products/collagen-boost-matcha-kit	55	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/PM40_CB.jpg?v=1723825886	0	2026-05-07 03:04:53.778548	2026-04-16 10:29:21.767979	2026-05-07 03:04:53.783183	bonsai_excluded	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
816	35	Superwhisk + Collagen Boost	https://golde.co/products/superwhisk-coconut-collagen	73	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/Superwhisk_CB.jpg?v=1723825839	0	2026-05-07 03:04:53.779067	2026-04-16 10:29:21.76798	2026-05-07 03:04:53.783184	beautyandother	\N	t	t	\N	0	0	beauty	shopify	m004|keyword_ma|80
817	35	Superwhisk	https://golde.co/products/superwhisk	45	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/IKH08618_round_6.jpg?v=1764955202	0	2026-05-07 03:04:53.779521	2026-04-16 10:29:21.76798	2026-05-07 03:04:53.783184	beautyandother	\N	t	t	\N	0	0	beauty	shopify	m004|keyword_ma|80
575	9	Gold Leaf Bunch Diamond Pendant	https://giva.co/products/gold-leaf-bunch-diamond-pendant	13422.12	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDLPD0173_1_5346700f-b1a5-4731-9572-66fb65021274.jpg?v=1754472731	0	2026-04-13 10:51:18.927007	2026-04-13 10:51:18.932614	2026-05-15 05:09:37.010697	Gold Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
577	9	Gold Star-Trail Lab Grown Diamond Pendant	https://giva.co/products/gold-star-trail-diamond-pendant	10433.06	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDLPD0185_1.jpg?v=1721899978	0	2026-04-13 10:51:18.928271	2026-04-13 10:51:18.932615	2026-05-15 05:09:37.010697	Gold Pendant	\N	t	t	\N	0	0	culture	shopify	backfill
578	9	Gold Swirl Lab Grown Diamond Nose Pin	https://giva.co/products/gold-swirl-diamond-nose-pin	9981.92	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/GDLNP0112_5.jpg?v=1747149462	0	2026-04-13 10:51:18.928881	2026-04-13 10:51:18.932616	2026-05-15 05:09:37.010697	Gold Nose Pin	\N	t	t	\N	0	0	culture	shopify	backfill
946	26	Digital Download of Your Artwork	https://crownandpaw.com/products/digital-download-of-your-artwork	10	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/DIGITALDOWNLOADOFYOURART.webp?v=1693970266	0	2026-05-07 03:04:44.487566	2026-04-16 10:29:45.355541	2026-05-07 03:04:44.507396	Download	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
852	32	City Candle Collection	https://hotellobbycandle.com/products/city-collection	325	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/City_Bundle_-_Regular.png?v=1761227418	0	2026-05-07 03:04:53.595216	2026-04-16 10:29:26.17608	2026-05-07 03:04:53.596464	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1137	21	Lightweight Terry Jogger | Velvet Morning	https://everlane.com/products/womens-lightweight-terry-jogger-velvet-morning	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/62c1b809_7404.jpg?v=1775001607	0	2026-04-22 04:48:53.439295	2026-04-22 04:18:56.731461	2026-04-22 04:48:53.441206	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1138	21	Halter Tank | White	https://everlane.com/products/womens-halter-tank-2-white	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/c8c0b8e5_392b.jpg?v=1775001606	0	2026-04-22 04:48:53.439718	2026-04-22 04:18:56.731461	2026-04-22 04:48:53.441206	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1139	21	Cropped Ribbed Crew in Everyday Cotton | Mayfly	https://everlane.com/products/womens-cropped-ribbed-crew-cotton-mayfly	128	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/6354d1f2_aee5.jpg?v=1776279607	0	2026-04-22 04:48:53.440114	2026-04-22 04:18:56.731461	2026-04-22 04:48:53.441206	Sweaters	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
855	31	Copy of Custom Standing Desk	https://oakywood.shop/products/copy-of-custom-standing-desk	1320	USD	https://cdn.shopify.com/s/files/1/2447/0423/products/WEB_01_29e8bbc1-add1-4e79-af8d-c666ebf13e5a.jpg?v=1762439855	0	2026-05-14 07:20:34.50925	2026-04-16 10:29:26.74017	2026-05-14 07:20:34.519759	Oaky	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
924	27	Paper Shoot Camera	https://papershoot.com/products/paper-shoot-camera	158.5	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera_ProductCassette_fa42f30a-9b08-45f2-a347-909a75628950.webp?v=1766027436	0	2026-05-14 07:20:29.409657	2026-04-16 10:29:29.298435	2026-05-15 05:09:37.010697	LP Hide	\N	t	t	\N	0	0	culture	shopify	backfill
853	31	Modular Drawer Organizers	https://oakywood.shop/products/modular-drawer-organizers	54	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/2_1800px_b2a5e430-0762-4398-94be-1f2abbac1e71.webp?v=1773272959	0	2026-05-14 07:20:34.50791	2026-04-16 10:29:26.740169	2026-05-15 05:09:37.010697	Oakywood	\N	t	t	\N	0	0	culture	shopify	backfill
854	31	Standing Desk Pro (Copy)	https://oakywood.shop/products/standing-desk-pro-copy	1496	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/standingdeskpro-oak-black-01-szare.jpg?v=1762440027	0	2026-05-14 07:20:34.508645	2026-04-16 10:29:26.74017	2026-05-15 05:09:37.010697	Oakywood	\N	t	t	\N	0	0	culture	shopify	backfill
856	31	Desk mounted Speaker Shelf	https://oakywood.shop/products/desk-mounted-speaker-shelf	109	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/04_1800px.webp?v=1761922078	0	2026-05-14 07:20:34.509728	2026-04-16 10:29:26.740171	2026-05-15 05:09:37.010697	attachables	\N	t	t	\N	0	0	culture	shopify	backfill
925	27	Vintage Pattern Aura Paper Panel	https://papershoot.com/products/pattern-aura-paper-panel	14.8	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Garden_Buzz.png?v=1763100514	0	2026-05-14 07:20:29.410265	2026-04-16 10:29:29.298436	2026-05-15 05:09:37.010697	Aura Case	\N	t	t	\N	0	0	culture	shopify	backfill
926	27	Vintage  Pattern Aura Paper Case	https://papershoot.com/products/pattern-aura-paper-case	35	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Garden_Buzz_7abbe2d6-47ac-489b-b0a7-a55f702dd19c.png?v=1763101279	0	2026-05-14 07:20:29.41059	2026-04-16 10:29:29.298436	2026-05-15 05:09:37.010697	Aura Case	\N	t	t	\N	0	0	culture	shopify	backfill
927	27	Vintage Pattern  Aura Paper Camera	https://papershoot.com/products/pattern-aura-paper-camera	169.9	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Electric_Garden_148cd82b-a116-4dc8-9641-851075a4b9c3.png?v=1763101915	0	2026-05-14 07:20:29.410872	2026-04-16 10:29:29.298437	2026-05-15 05:09:37.010697	Add On Discount (Bundle Camera)	\N	t	t	\N	0	0	culture	shopify	backfill
928	27	Featured Camera	https://papershoot.com/products/featured-cameras	158.5	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera_ProductCassette_fa42f30a-9b08-45f2-a347-909a75628950.webp?v=1766027436	0	2026-05-14 07:20:29.41117	2026-04-16 10:29:29.298437	2026-05-15 05:09:37.010697	camera	\N	t	t	\N	0	0	culture	shopify	backfill
1223	21	Tie-Neck Dress in Stretch Linen | Evergreen	https://everlane.com/products/womens-tie-neck-dress-in-stretch-linen-evergreen	168	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/830ba892_3e15.jpg?v=1776711604	0	2026-05-14 07:21:14.124235	2026-05-14 07:21:14.134015	2026-05-14 07:21:14.134016	Dresses	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
947	26	Preview Your Artwork Sooner	https://crownandpaw.com/products/first-in-line-artwork	10	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/skip_img.webp?v=1726776221	0	2026-05-07 03:04:44.488887	2026-04-16 10:29:45.355541	2026-05-07 03:04:44.507397	Skip Art Queue	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
948	26	The Werewolf & Wednesday - Custom Pet Canvas	https://crownandpaw.com/products/the-werewolf-wednesday-custom-pet-canvas	46.86	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Werewolf_Wednesday_-_Unframed_Canvas_on_Floor_Mock_Up.jpg?v=1758556196	0	2026-05-07 03:04:44.490137	2026-04-16 10:29:45.355541	2026-05-07 03:04:44.507397	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
341	5	Antiviral, antimicrobial Tesla Navigation Screen + Door Handle Protector	https://thekarelab.com/products/anti-virus-tesla-navigation-screen-door-handle-protector	520	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-tesla-navigation-screen-door-handle-protector-226964.png?v=1656197114	0	2026-05-14 07:20:27.767375	2026-04-11 06:27:34.217648	2026-05-14 07:20:27.777401	Vehicles	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
342	5	Antiviral, antimicrobial Tesla Door Handle Protector Gloss	https://thekarelab.com/products/anti-virus-tesla-door-handle-protector-gloss-matt-b2c	180	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-tesla-door-handle-protector-gloss-matt-253828.png?v=1663335002	0	2026-05-14 07:20:27.767847	2026-04-11 06:27:34.217648	2026-05-14 07:20:27.777402	Motor Vehicles	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
343	5	Antiviral, antimicrobial Tesla Navigation Screen Protector Anti-Glare	https://thekarelab.com/products/anti-virus-tesla-navigation-screen-protector-anti-glare-b2c	480	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-tesla-navigation-screen-protector-anti-glare-479020.png?v=1657538161	0	2026-05-14 07:20:27.768298	2026-04-11 06:27:34.217649	2026-05-14 07:20:27.777402	Screen Protectors	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
344	5	Antiviral, antimicrobial iPad Screen Protector Clear/ Anti-Glare	https://thekarelab.com/products/anti-virus-ipad-pro-screen-protector-12-9-clear-b2c	480	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-ipad-screen-protector-clear-anti-glare-726340.png?v=1657635569	0	2026-05-14 07:20:27.768839	2026-04-11 06:27:34.21765	2026-05-14 07:20:27.777402	Screen Protectors	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
345	5	Antiviral, antimicrobial iPhone Screen Protector Clear	https://thekarelab.com/products/anti-virus-iphone-13-pro-max-screen-protector-clear-b2c	180	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-iphone-screen-protector-clear-164333.png?v=1670741161	0	2026-05-14 07:20:27.769324	2026-04-11 06:27:34.217651	2026-05-14 07:20:27.777402	Screen Protectors	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
346	5	Antiviral, antimicrobial iPhone Screen Protector Clear & Anti-Glare	https://thekarelab.com/products/anti-virus-iphone-13-pro-max-screen-protector-clear	280	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/anti-virus-iphone-screen-protector-clear-anti-glare-102646.png?v=1648929453	0	2026-05-14 07:20:27.769768	2026-04-11 06:27:34.217651	2026-05-14 07:20:27.777403	Screen Protectors	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
349	5	FFP2 NR Face Mask	https://thekarelab.com/products/ffp2-nr-face-mask_b2c	50	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/ffp2-nr-face-mask-273096.png?v=1648929460	0	2026-05-14 07:20:27.771121	2026-04-11 06:27:34.217654	2026-05-14 07:20:27.777403	Medical Masks	\N	f	\N	\N	0	0	health	shopify	m004|keyword_ma|80
350	5	3 PLY Surgical Face Masks	https://thekarelab.com/products/3-ply-surgical-face-mask-b2c	32	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/3-ply-surgical-face-masks-292095.png?v=1648453570	0	2026-05-14 07:20:27.771562	2026-04-11 06:27:34.217654	2026-05-14 07:20:27.777404	Medical Masks	\N	f	\N	\N	0	0	health	shopify	m004|keyword_ma|80
351	5	Isolator Gown Level 1	https://thekarelab.com/products/isolator-gown-level-1-b2c	120	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/isolator-gown-level-1-170839.png?v=1648453572	0	2026-05-14 07:20:27.771977	2026-04-11 06:27:34.217655	2026-05-14 07:20:27.777404	Work Safety Protective Gear	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
355	5	Adult Cloth Face Mask	https://thekarelab.com/products/adult-cloth-mask-b2c	95	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/adult-cloth-face-mask-671939.png?v=1648323785	0	2026-05-14 07:20:27.77367	2026-04-11 06:27:34.217658	2026-05-14 07:20:27.777405	Masks	\N	f	\N	\N	0	0	adult-products	shopify	m004|keyword_ma|80
949	26	The Wednesday - Custom Pet Canvas	https://crownandpaw.com/products/the-wednesday-custom-pet-canvas	40.16	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Wednesday_-_Unframed_Canvas_on_Floor_Mock_Up.jpg?v=1758556081	0	2026-05-07 03:04:44.491157	2026-04-16 10:29:45.355542	2026-05-07 03:04:44.507397	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
774	38	Rose Quartz Single or Double Strand Necklace	https://tinyrituals.co/products/rose-quartz-single-or-double-strand-necklace	148	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-SD240-RQ.jpg?v=1770932020	0	2026-04-22 04:18:59.305682	2026-04-16 10:29:17.594877	2026-04-22 04:18:59.307308	Necklace	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
764	38	Black Moonstone Crystal Bowl - Large - 1 of a Kind	https://tinyrituals.co/products/black-moonstone-bowl	265	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-BOWL-BMO-MI-1-2.jpg?v=1774294725	0	2026-05-14 07:21:51.429498	2026-04-16 10:29:17.59487	2026-05-14 07:21:51.432554	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
776	38	Angel Number Necklaces - Gold or Silver	https://tinyrituals.co/products/angel-number-necklaces-gold-or-silver	98	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/111-G.png?v=1775886367	0	2026-04-16 10:29:17.592804	2026-04-16 10:29:17.594878	2026-04-16 10:29:17.594878	Necklace	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
777	38	Amber Worry Stone	https://tinyrituals.co/products/amber-worry-stone	68	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-WS-AMB-QE-1.jpg?v=1770532979	0	2026-04-16 10:29:17.59328	2026-04-16 10:29:17.594879	2026-04-16 10:29:17.594879	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
778	38	Chakra Mini Hearts Gift Set - 7 Recharging Stones	https://tinyrituals.co/products/chakra-mini-hearts-7-recharging-stones	78	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-MINIHCHK7-JAS-1.jpg?v=1769747598	0	2026-04-16 10:29:17.593789	2026-04-16 10:29:17.594879	2026-04-16 10:29:17.594879	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1224	21	Twisted Pleat Tank in Silk Georgette | Heather Rose	https://everlane.com/products/womens-twisted-pleat-tank-silk-georgette-heather-rose	198	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/14ed5d61_ab71.jpg?v=1772665206	0	2026-05-14 07:21:14.124582	2026-05-14 07:21:14.134016	2026-05-14 07:21:14.134016	Woven Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1225	21	Soft Stretch U-Neck Tank | Aleutian	https://everlane.com/products/womens-soft-stretch-u-neck-tank-aleutian	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/0641fe5a_4a4a.jpg?v=1774389605	0	2026-05-14 07:21:14.124924	2026-05-14 07:21:14.134016	2026-05-14 07:21:14.134016	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1226	21	Notch Collar Shirt in Silk Georgette | Navy	https://everlane.com/products/womens-notch-collar-shirt-silk-georgette-navy	178	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/bd3f30d7_210d.jpg?v=1773871208	0	2026-05-14 07:21:14.125292	2026-05-14 07:21:14.134017	2026-05-14 07:21:14.134017	Woven Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1227	21	Tissue Layered Tank | Heathered Grey	https://everlane.com/products/womens-tissue-layered-tank-heathered-grey	58	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/474dae91_005d.jpg?v=1773698404	0	2026-05-14 07:21:14.125632	2026-05-14 07:21:14.134017	2026-05-14 07:21:14.134017	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1228	21	Maxi Dress in Silk Georgette | Floral/Black	https://everlane.com/products/womens-maxi-dress-in-silk-georgette-sweet-floral-black	348	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/24e304d6_50a2.jpg?v=1772661605	0	2026-05-14 07:21:14.125951	2026-05-14 07:21:14.134017	2026-05-14 07:21:14.134017	Dresses	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
772	38	Copper Wire Wrap Earrings - Limited Edition	https://tinyrituals.co/products/copper-wire-earrings	78	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/products/TR-MU54-2.jpg?v=1735111440	0	2026-04-22 04:18:59.304662	2026-04-16 10:29:17.594875	2026-04-22 04:18:59.307307	Earring	\N	f	f	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
773	38	Mystic Topaz Emerald Cut Pendant Necklace	https://tinyrituals.co/products/rare-mystic-topaz-emerald-cut-pendant-necklace	195	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-MST-RDP-476-RJ.jpg?v=1750887293	0	2026-04-22 04:18:59.30517	2026-04-16 10:29:17.594876	2026-04-22 04:18:59.307308	Necklace	\N	f	f	\N	0	0	women-tops	shopify	m004|keyword_ma|80
923	27	Filter Card -Burgundy	https://papershoot.com/products/filter-card-burgundy	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Burgundy.png?v=1766570318	0	2026-05-14 07:20:29.409248	2026-04-16 10:29:29.298435	2026-05-14 07:20:29.415628	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
950	26	The Werewolf & Wednesday - Custom Pet Poster	https://crownandpaw.com/products/the-werewolf-wednesday-custom-pet-poster	89.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Werewolf_Wednesday_-_Framed_Poster_Black_Mock_Up.jpg?v=1758555797	0	2026-05-07 03:04:44.492241	2026-04-16 10:29:45.355542	2026-05-07 03:04:44.507397	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
951	26	The Wednesday - Custom Pet Poster	https://crownandpaw.com/products/the-wednesday-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Wednesday_-_Framed_Poster_Black_Mock_Up.jpg?v=1758555902	0	2026-05-07 03:04:44.493076	2026-04-16 10:29:45.355543	2026-05-07 03:04:44.507398	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
952	26	Count Barkula - Custom Pet Poster	https://crownandpaw.com/products/count-barkula-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/Count_Barkula_-_Unframed_Poster_Mock_Up.jpg?v=1758279412	0	2026-05-07 03:04:44.493812	2026-04-16 10:29:45.355543	2026-05-07 03:04:44.507398	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
953	26	Count Barkula - Custom Pet Canvas	https://crownandpaw.com/products/count-barkula-custom-pet-canvas	40.16	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/CountBarkula-UnframedCanvasonFloorMockUp_5ba6de95-52ef-403d-8aec-10f33946a76a.jpg?v=1758279203	0	2026-05-07 03:04:44.49486	2026-04-16 10:29:45.355543	2026-05-07 03:04:44.507398	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
954	26	The Dancing Clown - Custom Pet Poster	https://crownandpaw.com/products/the-dancing-clown-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Dancing_Clown_-_Unframed_Poster_Mock_Up.jpg?v=1758279594	0	2026-05-07 03:04:44.49557	2026-04-16 10:29:45.355544	2026-05-07 03:04:44.507398	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
1229	21	Tissue Layered Tank | Black	https://everlane.com/products/womens-tissue-layered-tank-black	58	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/b4e157cb_51d2.jpg?v=1773698403	0	2026-05-14 07:21:14.126301	2026-05-14 07:21:14.134018	2026-05-14 07:21:14.134018	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
775	38	Mystic Topaz Oval Pendant	https://tinyrituals.co/products/rare-mystic-topaz-oval-pendant	215	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-MST-RDP-478-RJ-2.jpg?v=1771049896	0	2026-04-22 04:18:59.306209	2026-04-16 10:29:17.594877	2026-04-22 04:18:59.307308	Necklace	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1042	38	Blue Calcite Sphere- Large - 1 of a Kind	https://tinyrituals.co/products/blue-calcite-sphere-large-1-of-a-kind	178	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-SPHERE-BCAL-MI-1.jpg?v=1776229235	0	2026-05-14 07:21:51.422884	2026-04-21 10:23:01.473315	2026-05-14 07:21:51.432556	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
495	16	The Stanley 1913 x Nelly Korda All Day Slim Bottle	https://stanley1913.com/products/stanley-1913-x-nelly-korda-all-day-slim-bottle	40	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-The_All_Day_Slim_Bottle_20OZ_-_Nelly_Korda_Pinstripe_-_Front.png?v=1775146380	0	2026-05-07 03:04:43.798706	2026-04-11 08:53:26.444752	2026-05-07 03:04:43.807648	normal	\N	t	f	2026-04-21 10:23:17.580954	0	0	\N	shopify	m004|uncategori|0
1043	38	Blue Calcite Egg - 1 of a Kind	https://tinyrituals.co/products/blue-calcite-egg	58	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/1_94664bdd-957d-40cb-a9e5-80eac1e84d6e.jpg?v=1775777442	0	2026-05-14 07:21:51.423303	2026-04-21 10:23:01.473316	2026-05-14 07:21:51.432556	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1044	38	Blue Calcite Obelisk - 1 of a Kind	https://tinyrituals.co/products/blue-calcite-obelisk-1-of-a-kind	58	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFT-BCAL-MI-1-1.jpg?v=1775785602	0	2026-05-14 07:21:51.423708	2026-04-21 10:23:01.473317	2026-05-14 07:21:51.432556	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1230	21	Soft Stretch U-Neck Tank | Bone	https://everlane.com/products/womens-soft-stretch-u-neck-tank-bone	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/a665066b_4c3b.jpg?v=1774375206	0	2026-05-14 07:21:14.126594	2026-05-14 07:21:14.134018	2026-05-14 07:21:14.134018	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1231	21	Soft Stretch U-Neck Tank | Henna Red	https://everlane.com/products/womens-soft-stretch-u-neck-tank-henna-red	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/45cfc201_5c5e.jpg?v=1773871207	0	2026-05-14 07:21:14.127586	2026-05-14 07:21:14.134018	2026-05-14 07:21:14.134018	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1232	21	Button-Front Tank in Tape Yarn | Bone	https://everlane.com/products/womens-tie-front-tank-in-tape-yarn-bone	128	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/e19a30f8_c9a9.jpg?v=1773871205	0	2026-05-14 07:21:14.127911	2026-05-14 07:21:14.134019	2026-05-14 07:21:14.134019	Sweaters	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1233	21	Midi Dress in Cotton Silk Voile | Passion Fruit	https://everlane.com/products/womens-midi-dress-in-cotton-silk-voile-passion-fruit	228	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/83b72468_813f.jpg?v=1772154014	0	2026-05-14 07:21:14.128256	2026-05-14 07:21:14.134019	2026-05-14 07:21:14.134019	Dresses	\N	f	f	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
1234	21	Midi Dress in Cotton Silk Voile | Bone	https://everlane.com/products/womens-midi-dress-in-cotton-silk-voile-bone	228	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/ff7bf9dd_d343.jpg?v=1771628409	0	2026-05-14 07:21:14.128548	2026-05-14 07:21:14.134019	2026-05-14 07:21:14.13402	Dresses	\N	f	f	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
1235	21	Muscle Shirtdress in Lightweight Cotton | Henna Red	https://everlane.com/products/womens-muscle-shirtdress-light-cotton-henna-red	168	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/6a457f6f_a897.jpg?v=1772064018	0	2026-05-14 07:21:14.128829	2026-05-14 07:21:14.13402	2026-05-14 07:21:14.13402	Dresses	\N	f	f	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
1236	21	Muscle Shirt in Lightweight Cotton | White	https://everlane.com/products/womens-muscle-shirt-lightweight-cotton-white	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/c66ecfae_d4b3.jpg?v=1772236806	0	2026-05-14 07:21:14.129126	2026-05-14 07:21:14.13402	2026-05-14 07:21:14.13402	Woven Tops	\N	f	f	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1237	21	Muscle Shirt in Lightweight Cotton | Henna Red	https://everlane.com/products/womens-muscle-shirt-lightweight-cotton-henna-red	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/b81ec458_6919.jpg?v=1772568005	0	2026-05-14 07:21:14.129474	2026-05-14 07:21:14.134021	2026-05-14 07:21:14.134021	Woven Tops	\N	f	f	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1238	21	Cuff Detail Shirt in Lightweight Cotton | Navy	https://everlane.com/products/womens-cuff-shirt-lightweight-cotton-navy	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/bd51f063_caad.jpg?v=1772060410	0	2026-05-14 07:21:14.129781	2026-05-14 07:21:14.134021	2026-05-14 07:21:14.134021	Woven Tops	\N	f	f	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1239	21	Muscle Shirt in Lightweight Cotton | Black	https://everlane.com/products/womens-muscle-shirt-lightweight-cotton-black	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/ac335717_9f54.jpg?v=1772226014	0	2026-05-14 07:21:14.1301	2026-05-14 07:21:14.134021	2026-05-14 07:21:14.134021	Woven Tops	\N	f	f	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1240	21	Cuff Detail Shirt in Lightweight Cotton | White	https://everlane.com/products/womens-cuff-shirt-lightweight-cotton-white	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/28b87e5f_9af4.jpg?v=1772226012	0	2026-05-14 07:21:14.130432	2026-05-14 07:21:14.134022	2026-05-14 07:21:14.134022	Woven Tops	\N	f	f	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1241	21	Cuff Detail Shirt in Lightweight Cotton | Beech	https://everlane.com/products/womens-cuff-shirt-lightweight-cotton-beech	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/fc1c816f_ec99.jpg?v=1771981217	0	2026-05-14 07:21:14.130755	2026-05-14 07:21:14.134022	2026-05-14 07:21:14.134022	Woven Tops	\N	f	f	\N	0	0	women-tops	shopify	m004|keyword_ma|80
127	7	Champagne Bottle Bag | Silver	https://coreyashford.com/products/bottle-bag-silver	95	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/champagne-bag_5a371403-6422-4ad6-9c91-08f581a1fa3b.jpg?v=1761568265	0	2026-04-21 10:23:11.199001	2026-04-10 10:19:59.560139	2026-04-21 10:23:11.215679	lifestyle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
128	7	Champagne Bottle Bag | Gold	https://coreyashford.com/products/bottle-bag-gold	95	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/bottle-bag-gold.jpg?v=1760750972	0	2026-04-21 10:23:11.19984	2026-04-10 10:19:59.560139	2026-04-21 10:23:11.215679	lifestyle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
955	26	The Dancing Clown - Custom Pet Canvas	https://crownandpaw.com/products/the-dancing-clown-custom-pet-canvas	40.16	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Dancing_Clown_-_Unframed_Canvas_on_Floor_Mock_Up.jpg?v=1758279741	0	2026-05-07 03:04:44.496179	2026-04-16 10:29:45.355544	2026-05-07 03:04:44.507399	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
956	26	Puppy's Play - Custom Pet Canvas	https://crownandpaw.com/products/puppys-play-custom-pet-canvas	40.16	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/Puppy_sPlay-UnframedCanvasonFloorMockUp.jpg?v=1758279940	0	2026-05-07 03:04:44.497066	2026-04-16 10:29:45.355545	2026-05-07 03:04:44.507399	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
1242	21	Muscle Shirtdress in Lightweight Cotton | Black	https://everlane.com/products/womens-muscle-shirtdress-light-cotton-black	168	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/dbf042cd_1096.jpg?v=1771628407	0	2026-05-14 07:21:14.131078	2026-05-14 07:21:14.134022	2026-05-14 07:21:14.134022	Dresses	\N	f	f	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
862	31	Desk Shelf Bundle with Drawer & Laptop Stand (Large)	https://oakywood.shop/products/desk-shelf-bundle-with-drawer-laptop-stand-copy	400	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/deskshelflaptopbundle-oak-black-single-01.webp?v=1762440339	0	2026-05-14 07:20:34.512805	2026-04-16 10:29:26.740174	2026-05-14 07:20:34.51976	bundle	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
863	31	Desk Shelf Bundle with Drawer & Laptop Stand (Medium)	https://oakywood.shop/products/desk-shelf-bundle-with-drawer-laptop-stand	390	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/deskshelflaptopbundle-oak-black-single-01.webp?v=1762440339	0	2026-05-14 07:20:34.513221	2026-04-16 10:29:26.740174	2026-05-14 07:20:34.519761	bundle	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
864	31	Desk Shelf Bundle - Drawer & Laptop Stand	https://oakywood.shop/products/desk-shelf-bundle-drawer-laptop-stand	390	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/deskshelflaptopbundle-oak-black-single-01_341fa444-fb2f-46f6-a9a9-9a5c4bd04a63.webp?v=1762440371	0	2026-05-14 07:20:34.513606	2026-04-16 10:29:26.740175	2026-05-14 07:20:34.519761	all	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
865	31	Copy laptop dock	https://oakywood.shop/products/copy-laptop-dock	98	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/028.jpg?v=1762439731	0	2026-05-14 07:20:34.513972	2026-04-16 10:29:26.740175	2026-05-14 07:20:34.519761	Oakywood	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1243	21	Notch Collar Shirt in Silk Georgette | Heather Rose	https://everlane.com/products/womens-notch-collar-shirt-silk-georgette-heather-rose	178	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/9bca45ba_d2ab.jpg?v=1773878406	0	2026-05-14 07:21:14.131387	2026-05-14 07:21:14.134023	2026-05-14 07:21:14.134023	Woven Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1244	21	Way-High® A-Line Denim Short | Tungsten Rinse	https://everlane.com/products/womens-way-high-a-line-denim-short-tungsten-rinse	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/996f124c_0473.jpg?v=1772575205	0	2026-05-14 07:21:14.131686	2026-05-14 07:21:14.134023	2026-05-14 07:21:14.134023	Denim	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1245	21	The Must-Have Shirt in Washable Silk | Bone / Rose	https://everlane.com/products/womens-clean-silk-relaxed-shirt-bone-rose	168	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/c1358cf0_9b94.jpg?v=1778259603	0	2026-05-14 07:21:14.131994	2026-05-14 07:21:14.134023	2026-05-14 07:21:14.134024	Woven Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
823	32	Holiday Five Wick Candle	https://hotellobbycandle.com/products/holiday-five-wick-candle	225	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Holiday5-Regular.png?v=1762198634	0	2026-05-07 03:04:53.576809	2026-04-16 10:29:26.176064	2026-05-07 03:04:53.596457	Candle	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
1040	31	Desk Organizer with compartments	https://oakywood.shop/products/desk-organizer-with-compartments	87	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/2_1800px_cb03dbbf-e46e-4ec0-9baa-3d5de06622a1.webp?v=1775764869	0	2026-05-14 07:20:34.50643	2026-04-21 10:23:00.727641	2026-05-14 07:20:34.519764	archive collection	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
957	26	Puppy's Play - Custom Pet Poster	https://crownandpaw.com/products/puppys-play-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/Puppy_s_Play_-_Unframed_Poster_Mock_Up.jpg?v=1758280152	0	2026-05-07 03:04:44.497917	2026-04-16 10:29:45.355545	2026-05-07 03:04:44.507399	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
958	26	The Howloween Renaissance - Custom Pet Poster	https://crownandpaw.com/products/the-howloween-renaissance-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Howloween_Renaissance_-_Unframed_Poster_Mock_Up.jpg?v=1758280294	0	2026-05-07 03:04:44.49864	2026-04-16 10:29:45.355545	2026-05-07 03:04:44.507399	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
959	26	The Howloween Renaissance - Custom Pet Canvas	https://crownandpaw.com/products/the-howloween-renaissance-custom-pet-canvas	40.16	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/TheHowloweenRenaissance-UnframedCanvasonFloorMockUp.jpg?v=1758280541	0	2026-05-07 03:04:44.499142	2026-04-16 10:29:45.355546	2026-05-07 03:04:44.5074	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
960	26	Personalized Halloween Cartoon Pet Face T Shirt	https://crownandpaw.com/products/personalized-halloween-cartoon-pet-face-t-shirt	29.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/68c92c37c3dcf.webp?v=1758014545	0	2026-05-07 03:04:44.499695	2026-04-16 10:29:45.355547	2026-05-07 03:04:44.5074	Customizer	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
961	26	Personalized Too Cute to Spook Halloween Pet Face Sweatshirt	https://crownandpaw.com/products/personalized-too-cute-to-spook-halloween-pet-face-sweatshirt	39.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/68c88210ce88e.webp?v=1758014406	0	2026-05-07 03:04:44.500386	2026-04-16 10:29:45.355547	2026-05-07 03:04:44.5074	Customizer	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
963	26	The Miss Honey - Custom Pet Poster	https://crownandpaw.com/products/the-miss-honey-custom-pet-poster	89.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Miss_Honey_-_Framed_Poster_Black_Mock_Up.jpg?v=1756397944	0	2026-05-07 03:04:44.501755	2026-04-16 10:29:45.355548	2026-05-07 03:04:44.507401	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
964	26	The Karate Duo - Custom Pet Poster	https://crownandpaw.com/products/the-karate-duo-custom-pet-poster	89.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Karate_Duo_-_Framed_Poster_Black_Mock_Up.jpg?v=1756397720	0	2026-05-07 03:04:44.502257	2026-04-16 10:29:45.355548	2026-05-07 03:04:44.507401	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
965	26	Marty and Doc - Custom Pet Poster	https://crownandpaw.com/products/marty-and-doc-custom-pet-poster	89.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/Marty_Doc_-_Framed_Poster_Black_Mock_Up.jpg?v=1756397448	0	2026-05-07 03:04:44.502855	2026-04-16 10:29:45.355549	2026-05-07 03:04:44.507401	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
1180	26	Custom Gallery Quality Pet Portrait	https://crownandpaw.com/products/custom-ai-pet-portrait	29	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/CORE_AESTHETIC_ANCHOR___202604211653_4.jpg?v=1776784084	0	2026-05-07 03:04:44.483032	2026-05-07 03:04:44.511033	2026-05-07 03:04:44.511034	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
700	33	CurrentBody Skin LED Multi-Light Mask & Hair Growth Helmet	https://currentbody.com/products/currentbody-skin-multi-light-mask-hair-growth-helmet	1034.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Multi-light_and_Hair_Growth_Bundle_c9dd91cd-7cda-4b89-b124-4ac8538e8ffe.png?v=1775559179	0	2026-05-14 07:21:16.386589	2026-04-16 10:29:11.565067	2026-05-14 07:21:16.388329	Affiliate Bundle	\N	t	t	\N	0	0	beauty-hair	shopify	m004|keyword_ma|80
876	31	Laptop Mount for Desk Shelf	https://oakywood.shop/products/desk-shelf-laptop-mount	120	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/deskshelflaptopmount-black-02.webp?v=1762440203	0	2026-05-14 07:20:34.518059	2026-04-16 10:29:26.74018	2026-05-14 07:20:34.519763	20%	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
469	15	Yin Time	https://elixhealing.com/products/yin-time-2	38	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/1A.png?v=1750863947	0	2026-04-21 10:23:09.213777	2026-04-11 08:50:45.10094	2026-04-21 10:23:09.235805	ingredient: Ginger	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
713	33	CurrentBody Skin LED Face Mask Series 2 & Green Tea Serum - Special Offer	https://currentbody.com/products/currentbody-skin-led-light-therapy-mask-green-tea-set-offer	410.3	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/Series_2_Green_tea_serum.png?v=1753453443	0	2026-05-14 07:21:16.382657	2026-04-16 10:29:11.565073	2026-05-14 07:21:16.38833	Affiliate Bundle	\N	t	t	\N	0	0	beauty-skincare	shopify	m004|keyword_ma|80
1247	33	CurrentBody Skin Green Tea Serum (30ml)	https://currentbody.com/products/currentbody-skin-green-tea-serum-thirtyml	45.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/green_tea_serum_1.png?v=1769620802	0	2026-05-14 07:21:16.374162	2026-05-14 07:21:16.389842	2026-05-14 07:21:16.389842	LED	\N	t	t	\N	0	0	beauty-skincare	shopify	m004|keyword_ma|80
867	31	Dual Laptop Dock (Copy)	https://oakywood.shop/products/dual-laptop-dock-copy	98	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/028.jpg?v=1762439731	0	2026-05-14 07:20:34.514746	2026-04-16 10:29:26.740176	2026-05-14 07:20:34.519761	Laptop stand	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1253	33	CurrentBody Skin Laser Hair Removal Device	https://currentbody.com/products/currentbody-skin-laser-hair-removal-device	579.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/laser-hair-removal-currentbody-skin-1.jpg?v=1763377374	0	2026-05-14 07:21:16.377776	2026-05-14 07:21:16.389844	2026-05-14 07:21:16.389845	Laser Hair Removal	\N	t	t	\N	0	0	beauty-hair	shopify	m004|keyword_ma|80
738	37	5mm Curb Chain - 18K Gold - 22"	https://ridge.com/products/5mm-curb-chain-18k-gold-22	175	USD	\N	0	2026-05-14 07:21:41.352168	2026-04-16 10:29:16.976847	2026-05-14 07:21:41.366096	Jewelry - Chains & Rings - 5mm Curb Chain - SINGLE	\N	t	f	2026-05-07 03:04:49.508422	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1257	33	CurrentBody Skin LED Face & Hair Kit	https://currentbody.com/products/currentbody-skin-led-face-hair-kit	945.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/hair_led_kit.jpg?v=1776415040	0	2026-05-14 07:21:16.38068	2026-05-14 07:21:16.389846	2026-05-14 07:21:16.389846	Device	\N	t	t	\N	0	0	beauty-hair	shopify	m004|keyword_ma|80
1259	33	CurrentBody Skin LED Face Mask & Green Tea Serum (30ml)	https://currentbody.com/products/currentbody-skin-led-light-therapy-mask-green-tea-set	325.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/series1-currentbody-skin-led-mask-green-tea_a14d2ef8-5a1a-4516-963a-338de1d0fd22.jpg?v=1748013907	0	2026-05-14 07:21:16.382208	2026-05-14 07:21:16.389847	2026-05-14 07:21:16.389847	LED	\N	t	t	\N	0	0	beauty-skincare	shopify	m004|keyword_ma|80
1260	33	CurrentBody Skin LED Hair Growth Helmet	https://currentbody.com/products/currentbody-skin-led-hair-regrowth-device	649.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/currentbody-led-hair-growth-helmet-front-view-4.png?v=1776350880	0	2026-05-14 07:21:16.38309	2026-05-14 07:21:16.389847	2026-05-14 07:21:16.389847	Hair Regrowth	\N	t	t	\N	0	0	beauty-hair	shopify	m004|keyword_ma|80
1199	37	5mm Curb Chain - Titanium - 22"	https://ridge.com/products/5mm-curb-chain-titanium-22	245	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Titanium-Chain-Tile_THUMBNAIL_38355a04-db2d-48cd-820b-19aa9baf177e.jpg?v=1777913085	0	2026-05-14 07:21:41.362934	2026-05-07 03:04:49.513292	2026-05-14 07:21:41.367776	Jewelry - Chains - 5mm Curb Chain - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1111	21	Canvas Mini Lug Tote | Black	https://everlane.com/products/womens-lug-mini-canvas-tote-bag-black	168	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/36e3276c_0cdf.jpg?v=1768939208	0	2026-04-22 04:48:53.42784	2026-04-22 04:18:56.731452	2026-04-22 04:48:53.4412	Bags	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
1112	21	Linen Easy Short | Agave Green	https://everlane.com/products/mens-linen-easy-short-agave-green	88	USD	\N	0	2026-04-22 04:48:53.428423	2026-04-22 04:18:56.731453	2026-04-22 04:48:53.4412	algolia-ignore	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1113	21	Archive Standard-Fit Cotton Crew | Skywriting	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-skywriting-blue	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/8c0a4552_ae0a.jpg?v=1776448803	0	2026-04-22 04:48:53.428927	2026-04-22 04:18:56.731453	2026-04-22 04:48:53.4412	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1114	21	Archive Standard-Fit Cotton Crew | Aleutian	https://everlane.com/products/mens-archive-standard-fit-cotton-crew-aleutian-blue	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/fff6d466_45f8.jpg?v=1775674815	0	2026-04-22 04:48:53.429471	2026-04-22 04:18:56.731453	2026-04-22 04:48:53.441201	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1115	21	Everyday Chino Short 7” | Olive Night	https://everlane.com/products/mens-everyday-chino-short-7-olive-night	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/0cb8c18a_ca77.jpg?v=1774382414	0	2026-04-22 04:48:53.429946	2026-04-22 04:18:56.731454	2026-04-22 04:48:53.441201	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1116	21	Everyday Chino Short 9" | Black	https://everlane.com/products/mens-everyday-chino-short-9-black	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/a710e366_4072.jpg?v=1774382411	0	2026-04-22 04:48:53.43045	2026-04-22 04:18:56.731454	2026-04-22 04:48:53.441201	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1117	21	Archive Relaxed-Fit Cotton Crew | Skywriting	https://everlane.com/products/mens-archive-cotton-relaxed-fit-crew-skywriting-blue	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/bae6481b_ac23.jpg?v=1776182403	0	2026-04-22 04:48:53.430925	2026-04-22 04:18:56.731454	2026-04-22 04:48:53.441201	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1118	21	Everyday Chino Short 7” | Deep Navy	https://everlane.com/products/mens-everyday-chino-short-7-deep-navy	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/c581d556_03a9.jpg?v=1774382412	0	2026-04-22 04:48:53.431417	2026-04-22 04:18:56.731455	2026-04-22 04:48:53.441202	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1119	21	Everyday Chino Short 7” | Slate Grey	https://everlane.com/products/mens-everyday-chino-short-7-slate-grey	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/a235e90d_6dee.jpg?v=1774382414	0	2026-04-22 04:48:53.431928	2026-04-22 04:18:56.731455	2026-04-22 04:48:53.441202	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1120	21	Everyday Chino Short 7” | Trench Coat Khaki	https://everlane.com/products/mens-everyday-chino-short-7-trench-coat-khaki	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/2a0f4077_7592.jpg?v=1774382413	0	2026-04-22 04:48:53.43236	2026-04-22 04:18:56.731455	2026-04-22 04:48:53.441202	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1121	21	Everyday Chino Short 9" | Trench Coat Khaki	https://everlane.com/products/mens-everyday-chino-short-9-trench-coat-khaki	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/e1e326f3_ceaf.jpg?v=1774382411	0	2026-04-22 04:48:53.43279	2026-04-22 04:18:56.731456	2026-04-22 04:48:53.441202	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1122	21	Everyday Chino Short 7” | Black	https://everlane.com/products/mens-everyday-chino-short-7-black	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/bc547479_ff67.jpg?v=1774382412	0	2026-04-22 04:48:53.433211	2026-04-22 04:18:56.731456	2026-04-22 04:48:53.441202	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1123	21	Everyday Chino Short 9" | Deep Navy	https://everlane.com/products/mens-everyday-chino-short-9-deep-navy	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/47b2480a_274a.jpg?v=1774382411	0	2026-04-22 04:48:53.433659	2026-04-22 04:18:56.731456	2026-04-22 04:48:53.441203	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1124	21	The Boxy Sweater in Everyday Cotton | Mayfly	https://everlane.com/products/womens-organic-cotton-crew-sweater-mayfly	108	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/71aea974_9619.jpg?v=1775606404	0	2026-04-22 04:48:53.434062	2026-04-22 04:18:56.731457	2026-04-22 04:48:53.441203	Sweaters	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1125	21	The Luxe Rib Funnel-Neck Tank | Graystone	https://everlane.com/products/womens-supima-micro-rib-funnel-neck-tank-graystone	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/14cb2eeb_a44d.jpg?v=1775001609	0	2026-04-22 04:48:53.434483	2026-04-22 04:18:56.731457	2026-04-22 04:48:53.441203	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1126	21	The Luxe Rib Long-Sleeve Crew | Coffee Bean	https://everlane.com/products/womens-supima-rib-long-sleeve-crew-coffee-bean	58	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/6a6abe0a_480b.jpg?v=1775001610	0	2026-04-22 04:48:53.434908	2026-04-22 04:18:56.731457	2026-04-22 04:48:53.441203	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1127	21	The Luxe Rib Crew | Coffee Bean	https://everlane.com/products/womens-supima-micro-rib-ss-crew-coffee-bien	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/a05de1af_5770.jpg?v=1774389608	0	2026-04-22 04:48:53.435324	2026-04-22 04:18:56.731458	2026-04-22 04:48:53.441204	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1128	21	The Everywhere Pant in Stretch Linen | Mayfly	https://everlane.com/products/womens-everywhere-pant-stretch-linen-mayfly	128	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/b31094d8_8ef1.jpg?v=1774054805	0	2026-04-22 04:48:53.435711	2026-04-22 04:18:56.731458	2026-04-22 04:48:53.441204	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1129	21	The Box-Cut Tee in Essential Cotton | Aleutian | Pocket	https://everlane.com/products/womens-organic-cotton-box-cut-tee-pocket-aleutian	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/4d957cf6_564e.jpg?v=1775001609	0	2026-04-22 04:48:53.436098	2026-04-22 04:18:56.731458	2026-04-22 04:48:53.441204	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1130	21	The Box-Cut Tee in Essential Cotton | Pale Peach | No Pocket	https://everlane.com/products/womens-organic-cotton-box-cut-tee-pale-peach	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/1479f92f_d98e.jpg?v=1776279611	0	2026-04-22 04:48:53.436509	2026-04-22 04:18:56.731459	2026-04-22 04:48:53.441204	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1131	21	The Box-Cut Tee in Essential Cotton | Aleutian | No Pocket	https://everlane.com/products/womens-organic-cotton-box-cut-tee-aleutian	38	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/b3b62653_62eb.jpg?v=1774386006	0	2026-04-22 04:48:53.436943	2026-04-22 04:18:56.731459	2026-04-22 04:48:53.441205	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1132	21	Seamed Wide-Leg Pant | Mayfly	https://everlane.com/products/womens-seamed-wide-leg-pant-mayfly	128	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/3afb809f_e3c0.jpg?v=1774054805	0	2026-04-22 04:48:53.437332	2026-04-22 04:18:56.731459	2026-04-22 04:48:53.441205	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1133	21	RetroSoft Cotton Crew | Henna Red	https://everlane.com/products/womens-retrosoft-cotton-crew-henna	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/c584dd2a_b52d.jpg?v=1776279609	0	2026-04-22 04:48:53.437753	2026-04-22 04:18:56.73146	2026-04-22 04:48:53.441205	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1134	21	RetroSoft Cotton Crew | Aleutian	https://everlane.com/products/womens-retrosoft-cotton-crew-aleutian	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/2634ce3e_7e0c.jpg?v=1775001608	0	2026-04-22 04:48:53.438128	2026-04-22 04:18:56.73146	2026-04-22 04:48:53.441205	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1135	21	Luxe Rib Racerback Tank | Coffee Bean	https://everlane.com/products/womens-luxe-rib-racerback-tank-coffee-bean	48	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/24cd3cc5_187f.jpg?v=1774389606	0	2026-04-22 04:48:53.438505	2026-04-22 04:18:56.73146	2026-04-22 04:48:53.441205	Knit Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1136	21	Lightweight Terry Jogger | Parchment	https://everlane.com/products/womens-lightweight-terry-jogger-parchment	98	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/66a8094f_7a38.jpg?v=1776279608	0	2026-04-22 04:48:53.438905	2026-04-22 04:18:56.73146	2026-04-22 04:48:53.441206	Bottoms	\N	t	t	\N	0	0	women-bottoms	shopify	m004|keyword_ma|80
1006	9	Golden Royal Red Earrings	https://giva.co/products/golden-royal-red-earrings	2599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER0214_1_1.jpg?v=1626336139	0	2026-04-16 10:38:49.151041	2026-04-16 10:38:49.170971	2026-04-16 10:38:49.170972	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1010	9	Rose Gold Zircon Quartet Ring	https://giva.co/products/pear-stones-charm-rose-gold-ring	1899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/R0556_1.jpg?v=1654779770	0	2026-04-16 10:38:49.155339	2026-04-16 10:38:49.170974	2026-04-16 10:38:49.170975	Rings	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1011	9	Anushka Sharma Rose Gold Matte Twig Earrings	https://giva.co/products/matte-rose-gold-twig-earrings	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0470_1_46b82920-2333-4219-8f8c-44c57ae8423d.jpg?v=1695446323	0	2026-04-16 10:38:49.156089	2026-04-16 10:38:49.170975	2026-04-16 10:38:49.170975	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
942	27	Feature Expansion Card	https://papershoot.com/products/feature-expansion-card	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/recording_0af71c4a-95f7-4582-8b5a-9da9ff0b5e93.png?v=1763987356	0	2026-04-22 04:48:58.812818	2026-04-16 10:29:29.298443	2026-04-22 04:48:58.814101	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1012	9	Silver Floral Flight Earrings	https://giva.co/products/silver-floral-flight-earrings	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03059_1.jpg?v=1746193163	0	2026-04-16 10:38:49.156825	2026-04-16 10:38:49.170976	2026-04-16 10:38:49.170976	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
962	26	Personalized Vintage Style Pet Face Hoodie	https://crownandpaw.com/products/personalized-vintage-style-pet-face-hoodie	44.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/68c49a0417815.webp?v=1757714954	0	2026-05-07 03:04:44.501073	2026-04-16 10:29:45.355547	2026-05-07 03:04:44.5074	Customizer	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
547	18	Luma Airpod Case	https://lumacases.com/products/luma-airpod-case	26.99	USD	https://cdn.shopify.com/s/files/1/0651/5625/1701/files/Your_paragraph_text_2.png?v=1764726047	0	2026-05-14 07:21:28.125333	2026-04-11 08:55:28.655797	2026-05-14 07:21:28.128974	Luma Cases	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
548	18	Luma Case Set – iPhone & AirPods Bundle	https://lumacases.com/products/luma-case-set-iphone-airpods-bundle-1	44.99	USD	https://cdn.shopify.com/s/files/1/0651/5625/1701/files/ChatGPT_Image_May_14_2025_06_05_09_PM.png?v=1747271138	0	2026-05-14 07:21:28.126693	2026-04-11 08:55:28.655798	2026-05-14 07:21:28.128975	Luma Cases	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
978	23	Postpartum Nutrient & Breastfeeding Support Ritual*	https://ritual.com/products/postpartum-breastfeeding-support-ritual	128	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/Essential_Natalbiotic_SkinTrioforPostnatal.webp?v=1773186390	0	2026-04-22 04:48:59.733086	2026-04-16 10:29:45.852241	2026-04-22 04:48:59.748169	bundle	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1008	9	Rose Gold Classic Layered Anklet	https://giva.co/products/rose-gold-classic-layered-anklet	2399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/A0199_2_f0fe3a0c-d2e9-4915-9caf-7c0c78f9f1b2.jpg?v=1721710403	0	2026-04-16 10:38:49.153657	2026-04-16 10:38:49.170973	2026-05-15 05:09:37.010697	Anklets	\N	t	t	\N	0	0	culture	shopify	backfill
1009	9	Silver Dua Kids Anklet	https://giva.co/products/silver-dua-kids-anklet	1099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/KA04_01_2.jpg?v=1750741701	0	2026-04-16 10:38:49.154394	2026-04-16 10:38:49.170974	2026-05-15 05:09:37.010697	Kids Anklets	\N	t	t	\N	0	0	culture	shopify	backfill
934	27	Gleam Frame Case	https://papershoot.com/products/gleam-frame-case	119.8	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/2025_PhotoShoot_CROZ_VintageT.png?v=1764135074	0	2026-05-14 07:20:29.413035	2026-04-16 10:29:29.29844	2026-05-15 05:09:37.010697	case	\N	t	t	\N	0	0	culture	shopify	backfill
935	27	Material Essence Case	https://papershoot.com/products/material-essence-case	39.9	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera-Vanguard.png?v=1764130223	0	2026-05-14 07:20:29.413319	2026-04-16 10:29:29.29844	2026-05-15 05:09:37.010697	case	\N	t	t	\N	0	0	culture	shopify	backfill
936	27	RetroWave Paper Case	https://papershoot.com/products/paper-case-cassette-copy	19.5	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/Paper_Shoot_Camera_ProductOld_Papersho_c776b184-242d-4a70-a6dc-f64abd3acb43.png?v=1764998958	0	2026-05-14 07:20:29.413593	2026-04-16 10:29:29.298441	2026-05-15 05:09:37.010697	case	\N	t	t	\N	0	0	culture	shopify	backfill
1014	9	Silver Minimalist Hoop Earrings	https://giva.co/products/silver-minimalist-hoop-earrings	5999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03567_1.jpg?v=1767360204	0	2026-04-16 10:38:49.158276	2026-04-16 10:38:49.170977	2026-04-16 10:38:49.170977	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1015	9	Golden Gleaming You Hoop Earrings	https://giva.co/products/golden-gleaming-you-hoop-earrings	5399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03575_1_330fa08f-5134-4b2a-b651-f993081c7fed.jpg?v=1767704539	0	2026-04-16 10:38:49.158997	2026-04-16 10:38:49.170977	2026-04-16 10:38:49.170977	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1017	9	Rose Gold Everlove Ring	https://giva.co/products/rose-gold-everlove-ring	2699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R02458_1.jpg?v=1769063089	0	2026-04-16 10:38:49.160239	2026-04-16 10:38:49.170978	2026-04-16 10:38:49.170979	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1018	9	Silver Sparkly Butterfly Kids Earrings (4-12 yrs)	https://giva.co/products/butterfly-kids-studs	1999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER01408_1.jpg?v=1661442527	0	2026-04-16 10:38:49.160807	2026-04-16 10:38:49.170979	2026-04-16 10:38:49.170979	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1019	9	Silver Layered Zirconia Statement Ring	https://giva.co/products/silver-layered-zirconia-statement-ring	4599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01593_1.jpg?v=1705649166	0	2026-04-16 10:38:49.161406	2026-04-16 10:38:49.17098	2026-04-16 10:38:49.17098	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1020	9	Silver Parley Ring	https://giva.co/products/silver-parley-ring	2399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01496_1.jpg?v=1709819724	0	2026-04-16 10:38:49.161965	2026-04-16 10:38:49.17098	2026-04-16 10:38:49.17098	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1021	9	Silver Black Ice Hoop Earring For Him	https://giva.co/products/silver-black-ice-hoop-earring-for-him	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER0110_1.jpg?v=1758205429	0	2026-04-16 10:38:49.162515	2026-04-16 10:38:49.170981	2026-04-16 10:38:49.170981	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1022	9	Silver Crystal Bloom Bracelet	https://giva.co/products/silver-crystal-bloom-bracelet	3999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01358_1.jpg?v=1764240794	0	2026-04-16 10:38:49.163076	2026-04-16 10:38:49.170981	2026-04-16 10:38:49.170982	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1023	9	Round Stoned Silver Open Ring	https://giva.co/products/round-stoned-silver-open-ring-1	3399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01473_1.jpg?v=1708004015	0	2026-04-16 10:38:49.163681	2026-04-16 10:38:49.170982	2026-04-16 10:38:49.170982	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1024	9	Silver Shining Star Earring For Men	https://giva.co/products/silver-zircon-earrings	1199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER03_1.jpg?v=1742467539	0	2026-04-16 10:38:49.164212	2026-04-16 10:38:49.170982	2026-04-16 10:38:49.170983	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1025	9	Rose Gold Lucky Hearts Kids Nazariya Bracelet (3-5 yrs)	https://giva.co/products/rose-gold-lucky-hearts-kids-nazariya-bracelet	1999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/BR0691_1-min.jpg?v=1674195344	0	2026-04-16 10:38:49.164765	2026-04-16 10:38:49.170983	2026-04-16 10:38:49.170983	Bracelet	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1028	9	Rose Gold Drop Wreath Ring	https://giva.co/products/rose-gold-drop-wreath-ring	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/R01604_1-min_eb48c937-10bb-4797-a817-15c25071e59a.jpg?v=1705037677	0	2026-04-16 10:38:49.166341	2026-04-16 10:38:49.170985	2026-04-16 10:38:49.170985	Rings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
989	23	Daily Shake Pregnancy & Postpartum	https://ritual.com/products/essential-protein-pregnancy-postpartum	44	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-PDPP-Bag.jpg?v=1770263120	0	2026-05-14 07:21:14.109551	2026-04-16 10:29:45.852246	2026-05-14 07:21:14.115114	18-49	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
994	23	Postnatal Multivitamin	https://ritual.com/products/essential-postnatal-multivitamin	39	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP-EPOST-Bottle-No-Essence.jpg?v=1770263105	0	2026-05-14 07:21:14.111483	2026-04-16 10:29:45.852249	2026-05-14 07:21:14.115115	18-49	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
1026	9	Rose Gold Drop Wreath Set of Three	https://giva.co/products/rose-gold-drop-wreath-set-of-three	8299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0583_PD0434_R01604_1.jpg?v=1714044072	0	2026-04-16 10:38:49.1653	2026-04-16 10:38:49.170984	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
1027	9	Rose Gold Drop Wreath Set of Two	https://giva.co/products/rose-gold-drop-wreath-set-of-two	5699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD0434_R01604_1.jpg?v=1714044171	0	2026-04-16 10:38:49.165851	2026-04-16 10:38:49.170984	2026-05-15 05:09:37.010697	Set	\N	t	t	\N	0	0	culture	shopify	backfill
996	23	Men’s Multivitamin 18+	https://ritual.com/products/essential-multivitamin-for-men	33	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP_EFM18_Pills_Animated.gif?v=1770263132	0	2026-05-14 07:21:14.112304	2026-04-16 10:29:45.85225	2026-05-14 07:21:14.115115	18-49	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
997	23	Prenatal Multivitamin	https://ritual.com/products/essential-prenatal-multivitamin	39	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP_EPRE_Bottle_No_Scent.jpg?v=1770263108	0	2026-05-14 07:21:14.112705	2026-04-16 10:29:45.852251	2026-05-14 07:21:14.115115	18-49	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
998	23	Women’s Multivitamin 18+	https://ritual.com/products/essential-for-women-multivitamin	33	USD	https://cdn.shopify.com/s/files/1/0626/8842/8126/files/PDP_EFW18_Bottle.jpg?v=1770263110	0	2026-05-14 07:21:14.113143	2026-04-16 10:29:45.852251	2026-05-14 07:21:14.115116	18-49	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
913	27	Filter Expansion Card	https://papershoot.com/products/filter-expansion-card	14	USD	https://cdn.shopify.com/s/files/1/0811/6715/5497/files/classic_1cb2b9a9-d7c6-4e91-ad48-f3d1b63490ef.png?v=1763985627	0	2026-05-14 07:20:29.405316	2026-04-16 10:29:29.298429	2026-05-14 07:20:29.415626	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
765	38	Black Moonstone Heart - 1 of a Kind	https://tinyrituals.co/products/black-moonstone-heart	48	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFH-BMO-MI-1-1_d21fcbc4-f714-4a84-85b2-04d90dc41dca.jpg?v=1774647076	0	2026-05-14 07:21:51.429818	2026-04-16 10:29:17.594871	2026-05-14 07:21:51.432555	Accessories	\N	f	t	2026-05-07 03:05:01.077467	0	0	fashion-accessories	shopify	m004|keyword_ma|80
766	38	Black Moonstone Crystal Flame - 1 of a Kind	https://tinyrituals.co/products/black-moonstone-flame	78	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFF-BMO-MI-1-1_857777e2-8960-4e58-87b0-d491495b201f.jpg?v=1774632763	0	2026-05-14 07:21:51.43018	2026-04-16 10:29:17.594872	2026-05-14 07:21:51.432555	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
767	38	Skull Wrist Bracelet	https://tinyrituals.co/products/skull-wrist-bracelet	68	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/Skull_Wrist_Bracelet.png?v=1773186760	0	2026-05-14 07:21:51.430524	2026-04-16 10:29:17.594872	2026-05-14 07:21:51.432555	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
768	38	Tibetan Skull Bracelet	https://tinyrituals.co/products/tibetan-skull-bracelet	78	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TIBETAN_SKULL_BRACELET.jpg?v=1773186699	0	2026-05-14 07:21:51.430863	2026-04-16 10:29:17.594873	2026-05-14 07:21:51.432555	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
769	38	Hermit Healing Bracelet	https://tinyrituals.co/products/hermit-healing-bracelet	98	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/sivana-hermit-healing-bracelet-13192559755345.jpg?v=1773186638	0	2026-05-14 07:21:51.431185	2026-04-16 10:29:17.594873	2026-05-14 07:21:51.432555	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
666	29	Keychron J8 HE 8K Magnetic Switch Keyboard	https://keychron.com/products/keychron-j8-he-8k-magnetic-switch-keyboard	99.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-J8-HE-8K-Wired-Magnetic-Switch-Keyboard.jpg?v=1775027463	0	2026-05-14 07:21:29.222509	2026-04-16 10:29:10.03407	2026-05-14 07:21:29.22955	Custom Keyboards	\N	f	f	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
667	29	Keychron P6 Ultra 8K Wireless Custom Mechanical Keyboard	https://keychron.com/products/keychron-p6-ultra-8k-wireless-custom-mechanical-keyboard	199.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-P6-Ultra-8K-Wireless-RGB-Backlight-Swappable-Red-Switch-Knob-Version---Black.jpg?v=1774939536	0	2026-05-14 07:21:29.222881	2026-04-16 10:29:10.03407	2026-05-14 07:21:29.229551	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
682	29	Keychron V0 Ultra 8K Wireless Custom Number Pad	https://keychron.com/products/keychron-v0-ultra-8k-wireless-custom-number-pad	69.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-V0-Ultra-8K-Features.jpg?v=1772076822	0	2026-05-14 07:21:29.228204	2026-04-16 10:29:10.034078	2026-05-14 07:21:29.229553	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
683	29	Keychron V10 Ultra 8K Wireless Custom Mechanical Keyboard	https://keychron.com/products/keychron-v10-ultra-8k-wireless-custom-mechanical-keyboard	124.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-V10-Ultra-8K-Feature.jpg?v=1772073960	0	2026-05-14 07:21:29.228563	2026-04-16 10:29:10.034078	2026-05-14 07:21:29.229554	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
684	29	Keychron K2 HE Wireless Magnetic Switch Custom Keyboard - Resin Edition	https://keychron.com/products/keychron-k2-he-wireless-magnetic-switch-custom-keyboard-resin-edition	199.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-K2-HE-Resin-Eidtion-Features.jpg?v=1769570741	0	2026-05-14 07:21:29.228903	2026-04-16 10:29:10.034078	2026-05-14 07:21:29.229554	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
1263	29	Keychron Q11 Ultra 8K Wireless Custom Mechanical Keyboard	https://keychron.com/products/keychron-q11-ultra-8k-wireless-custom-mechanical-keyboard	239.99	USD	https://cdn.shopify.com/s/files/1/0059/0630/1017/files/Keychron-Q11-Ultra-8K-Features.jpg?v=1775037225	0	2026-05-14 07:21:29.216916	2026-05-14 07:21:29.231692	2026-05-14 07:21:29.231693	Custom Keyboards	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
517	17	Kiprun Kipstorm Lab Unisex Carbon Plate Running Shoes	https://decathlon.com/products/kiprun-kipstorm-lab-mens-carbon-plate-running-shoes-369831	350	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/8953316-default_5906aca4-4777-4ab2-97fb-0912600f32dd.jpg?v=1774444411	0	2026-04-21 10:23:09.885256	2026-04-11 08:54:53.631299	2026-04-21 10:23:09.933211	Shoes	\N	f	f	\N	0	0	sports-shoes	shopify	m004|keyword_ma|80
540	17	29L Rolltop Backpack	https://decathlon.com/products/29l-rolltop-backpack	89.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_3b1ecf29-2078-4d7e-af20-b388a03a9764.jpg?v=1775496347	0	2026-04-21 10:23:09.923997	2026-04-11 08:54:53.631313	2026-04-21 10:23:09.933218	Backpack	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
541	17	28L Sports Bag with Waterproof Pocket	https://decathlon.com/products/28l-sports-bag-with-waterproof-pocket	44.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_7773082d-ea4e-43db-aa98-d17eb642bcff.jpg?v=1775495694	0	2026-04-21 10:23:09.925069	2026-04-11 08:54:53.631314	2026-04-21 10:23:09.933218	Sport bag	\N	t	t	\N	0	0	sports	shopify	m004|keyword_ma|80
544	17	28L Sports Bag with Waterproof Pocket	https://decathlon.com/products/28l-sports-bag-with-waterproof-pocket-1	44.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_7c406bf6-80aa-436f-8d1e-2a19f448f0bd.jpg?v=1775496526	0	2026-04-21 10:23:09.929009	2026-04-11 08:54:53.631316	2026-04-21 10:23:09.933219	Sport bag	\N	t	t	\N	0	0	sports	shopify	m004|keyword_ma|80
545	17	10L Laptop Backpack	https://decathlon.com/products/10l-laptop-backpack-1	39.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_64279381-381d-4838-91db-50eea3ac1f0f.jpg?v=1775496505	0	2026-04-21 10:23:09.930891	2026-04-11 08:54:53.631317	2026-04-21 10:23:09.933219	Backpack	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1184	37	Curb Chain Kit - Titanium - Large	https://ridge.com/products/curb-chain-kit-titanium-large	275	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Titanium-Bundle-Tile_THUMBNAIL.jpg?v=1778011110	0	2026-05-14 07:21:41.354803	2026-05-07 03:04:49.513283	2026-05-14 07:21:41.366097	Jewelry - Kits - Curb Chain Kit - KIT	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1185	37	Curb Chain Kit - Titanium - Medium	https://ridge.com/products/curb-chain-kit-titanium-medium	275	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Titanium-Bundle-Tile_THUMBNAIL.jpg?v=1778011110	0	2026-05-14 07:21:41.355432	2026-05-07 03:04:49.513283	2026-05-14 07:21:41.366097	Jewelry - Kits - Curb Chain Kit - KIT	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1186	37	Curb Chain Kit - Platinum - Large	https://ridge.com/products/curb-chain-kit-platinum-large	199	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Platinum-Bundle-Tile_THUMBNAIL.jpg?v=1778010985	0	2026-05-14 07:21:41.355951	2026-05-07 03:04:49.513284	2026-05-14 07:21:41.366918	Jewelry - Kits - Curb Chain Kit - KIT	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1187	37	Curb Chain Kit - Platinum - Medium	https://ridge.com/products/curb-chain-kit-platinum-medium	199	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Platinum-Bundle-Tile_THUMBNAIL.jpg?v=1778010985	0	2026-05-14 07:21:41.357131	2026-05-07 03:04:49.513284	2026-05-14 07:21:41.366919	Jewelry - Kits - Curb Chain Kit - KIT	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1188	37	Curb Chain Kit - 18K Gold - Large	https://ridge.com/products/curb-chain-kit-18k-gold-large	199	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Gold-Bundle-Tile_THUMBNAIL.jpg?v=1778010831	0	2026-05-14 07:21:41.357814	2026-05-07 03:04:49.513285	2026-05-14 07:21:41.366919	Jewelry - Kits - Curb Chain Kit - KIT	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1189	37	Curb Chain Kit - 18K Gold - Medium	https://ridge.com/products/curb-chain-kit-18k-gold-medium	199	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Gold-Bundle-Tile_THUMBNAIL.jpg?v=1778010831	0	2026-05-14 07:21:41.358239	2026-05-07 03:04:49.513286	2026-05-14 07:21:41.366919	Jewelry - Kits - Curb Chain Kit - KIT	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1190	37	Godspeed Signet - Platinum	https://ridge.com/products/godspeed-signet-platinum	95	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Platinum-Signet-Tile_THUMBNAIL.jpg?v=1777917943	0	2026-05-14 07:21:41.358649	2026-05-07 03:04:49.513286	2026-05-14 07:21:41.366919	Jewelry - Jewelry Accessories - Godspeed Signet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1191	37	Godspeed Signet - Titanium	https://ridge.com/products/godspeed-signet-titanium	95	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Titanium-Signet-Tile_THUMBNAIL.jpg?v=1777917658	0	2026-05-14 07:21:41.359057	2026-05-07 03:04:49.513287	2026-05-14 07:21:41.36692	Jewelry - Jewelry Accessories - Godspeed Signet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1192	37	Godspeed Signet - 18K Gold	https://ridge.com/products/godspeed-signet-18k-gold	95	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Gold-Signet-Tile_THUMBNAIL.jpg?v=1777917454	0	2026-05-14 07:21:41.359458	2026-05-07 03:04:49.513287	2026-05-14 07:21:41.36692	Jewelry - Jewelry Accessories - Godspeed Signet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1193	37	6mm Curb Bracelet - Titanium - Medium	https://ridge.com/products/6mm-curb-bracelet-titanium-medium	175	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Titanium-Bracelet-Tile_THUMBNAIL_9695bd5e-d359-48b5-8459-8bea83111e84.jpg?v=1777912843	0	2026-05-14 07:21:41.35983	2026-05-07 03:04:49.513288	2026-05-14 07:21:41.36692	Jewelry - Chains - 6mm Curb Bracelet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1194	37	6mm Curb Bracelet - Titanium - Large	https://ridge.com/products/6mm-curb-bracelet-titanium-large	175	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Titanium-Bracelet-Tile_THUMBNAIL.jpg?v=1777912805	0	2026-05-14 07:21:41.36018	2026-05-07 03:04:49.513289	2026-05-14 07:21:41.36692	Jewelry - Chains - 6mm Curb Bracelet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1195	37	6mm Curb Bracelet - Platinum - Medium	https://ridge.com/products/6mm-curb-bracelet-platinum-medium	125	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Platinum-Bracelet-Tile_THUMBNAIL_3636c652-7bc1-493b-9b0e-49dbb2f94cdc.jpg?v=1777912774	0	2026-05-14 07:21:41.361508	2026-05-07 03:04:49.513289	2026-05-14 07:21:41.367774	Jewelry - Chains - 6mm Curb Bracelet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1196	37	6mm Curb Bracelet - Platinum - Large	https://ridge.com/products/6mm-curb-bracelet-platinum-large	125	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Platinum-Bracelet-Tile_THUMBNAIL.jpg?v=1777912742	0	2026-05-14 07:21:41.361876	2026-05-07 03:04:49.51329	2026-05-14 07:21:41.367775	Jewelry - Chains - 6mm Curb Bracelet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1197	37	6mm Curb Bracelet - 18K Gold - Medium	https://ridge.com/products/6mm-curb-bracelet-18k-gold-medium	125	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Gold-Bracelet-Tile_THUMBNAIL_6940e965-59d1-4234-94a5-93fa2466306d.jpg?v=1777912701	0	2026-05-14 07:21:41.362225	2026-05-07 03:04:49.51329	2026-05-14 07:21:41.367775	Jewelry - Chains - 6mm Curb Bracelet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
397	8	Lapis Lazuli Sphere	https://energymuse.com/products/lapis-lazuli-sphere-1	183.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/LapisLazuliSphere.png?v=1775758017	0	2026-04-21 10:23:08.865621	2026-04-11 06:31:33.849701	2026-04-21 10:23:08.885107	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
602	8	Himalayan Quartz Copper Necklace	https://energymuse.com/products/himalayan-quartz-copper-necklace	68.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/HimalayanQuartzCopperNecklace.png?v=1775866403	0	2026-04-21 10:23:08.858634	2026-04-14 03:05:56.461296	2026-04-21 10:23:08.885662	Jewelry	\N	f	t	2026-04-16 10:38:12.431482	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1002	8	Aegirine Crystal	https://energymuse.com/products/aegirine-crystal-1	49.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/Aegirine.png?v=1776104559	0	2026-04-21 10:23:08.84897	2026-04-16 10:38:12.454395	2026-04-21 10:23:08.887034	Crystals	\N	f	t	2026-04-21 10:23:08.84897	0	0	\N	shopify	m004|uncategori|0
1003	8	Rossmanite Crystal	https://energymuse.com/products/rossmanite-crystal	14.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/Rossmanite_2.png?v=1776299121	0	2026-04-21 10:23:08.852513	2026-04-16 10:38:12.454396	2026-04-21 10:23:08.887496	Crystals	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1004	8	Vivianite Slice	https://energymuse.com/products/vivianite-slice	29.16	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/VivianiteSlice.png?v=1776104693	0	2026-04-21 10:23:08.855112	2026-04-16 10:38:12.454397	2026-04-21 10:23:08.88797	Crystals	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1029	9	Golden Solitaire Heart Studs	https://giva.co/products/golden-solitaire-heart-studs	2899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02497_1.jpg?v=1696511182	0	2026-04-16 10:38:49.16685	2026-04-16 10:38:49.170985	2026-04-16 10:38:49.170986	Earrings	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1030	9	Golden Bezel Set Stud Earrings	https://giva.co/products/golden-bezel-set-stud-earrings	999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER03382_1.jpg?v=1764855018	0	2026-04-16 10:38:49.16733	2026-04-16 10:38:49.170986	2026-04-16 10:38:49.170986	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1031	9	Rose Gold Bold Red Earrings	https://giva.co/products/rose-gold-bold-red-earrings	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02598_1.jpg?v=1704370305	0	2026-04-16 10:38:49.167806	2026-04-16 10:38:49.170986	2026-04-16 10:38:49.170987	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1033	9	Golden Glinting Joy Zircon Earrings	https://giva.co/products/golden-glinting-joy-zircon-earrings	3499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0615_1-min.jpg?v=1715681180	0	2026-04-16 10:38:49.168847	2026-04-16 10:38:49.170988	2026-04-16 10:38:49.170988	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1035	9	Rose Gold Brilliant Red Eyebright Trio Necklace	https://giva.co/products/rose-gold-brilliant-red-eyebright-trio-necklace	6399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PD02449_1.jpg?v=1724835846	0	2026-04-16 10:38:49.169867	2026-04-16 10:38:49.170989	2026-04-16 10:38:49.170989	Pendant	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1080	25	Toilet Bowl Cleaner Tablet Refills	https://blueland.com/products/toilet-bowl-cleaner-tablet-refills-wild-lavender-10-count	14	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Toilet_Wild_Lav_Refill_10_CT_Final_2026_01.jpg?v=1771964227	0	2026-05-14 07:20:29.686848	2026-04-21 11:26:58.611645	2026-05-14 07:20:29.705055	Refills	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1081	25	Toilet Bowl Cleaner Sample Pack (3 Tablets)	https://blueland.com/products/toilet-bowl-cleaner-sample-pack-3-tablets	5	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/SIte_Singles_Toilet3Pack.jpg?v=1776380417	0	2026-05-14 07:20:29.687794	2026-04-21 11:26:58.611646	2026-05-14 07:20:29.705056	Samples	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1082	25	Hand Soap Pump	https://blueland.com/products/hand-soap-pump-f3	3	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/PLP_DTC_Replacements_Hand_Soap_Pump_Black_Final_2026.jpg?v=1770140851	0	2026-05-14 07:20:29.68866	2026-04-21 11:26:58.611646	2026-05-14 07:20:29.705056	Extras	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1083	25	1 Year of Wild Lavender Toilet Bowl Cleaner	https://blueland.com/products/1-year-of-toilet-bowl-cleaner-wild-lavender	118	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/PLP_DTC_AnnualBundles_Toilet_Wild_Lavender_Finals_2026.jpg?v=1771441117	0	2026-05-14 07:20:29.689513	2026-04-21 11:26:58.611647	2026-05-14 07:20:29.705057	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1198	37	6mm Curb Bracelet - 18K Gold - Large	https://ridge.com/products/6mm-curb-bracelet-18k-gold-large	125	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Gold-Bracelet-Tile_THUMBNAIL.jpg?v=1777912336	0	2026-05-14 07:21:41.36257	2026-05-07 03:04:49.513291	2026-05-14 07:21:41.367776	Jewelry - Chains - 6mm Curb Bracelet - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1200	37	5mm Curb Chain - Titanium - 20"	https://ridge.com/products/5mm-curb-chain-titanium-20	245	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Titanium-Chain-Tile_THUMBNAIL.jpg?v=1777913053	0	2026-05-14 07:21:41.363296	2026-05-07 03:04:49.513292	2026-05-14 07:21:41.367776	Jewelry - Chains - 5mm Curb Chain - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1084	25	Toilet Bowl Cleaner Tablet Refills	https://blueland.com/products/toilet-cleaner-refill-packs-wild-lavender	18	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Toilet_Wild_Lav_Refill_Final_2026_01.jpg?v=1769801583	0	2026-05-14 07:20:29.690222	2026-04-21 11:26:58.611647	2026-05-14 07:20:29.705057	Refills	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1201	37	5mm Curb Chain - Platinum - 22"	https://ridge.com/products/5mm-curb-chain-platinum-22	175	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Platinum-Chain-Tile_THUMBNAIL_b3afa28f-9a59-4596-b98e-5f60be32d4ae.jpg?v=1777913013	0	2026-05-14 07:21:41.363639	2026-05-07 03:04:49.513293	2026-05-14 07:21:41.367776	Jewelry - Chains - 5mm Curb Chain - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1202	37	5mm Curb Chain - Platinum - 20"	https://ridge.com/products/5mm-curb-chain-platinum-20	175	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Platinum-Chain-Tile_THUMBNAIL.jpg?v=1777912975	0	2026-05-14 07:21:41.363962	2026-05-07 03:04:49.513293	2026-05-14 07:21:41.367776	Jewelry - Chains - 5mm Curb Chain - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1203	37	5mm Curb Chain - 18K Gold - 20"	https://ridge.com/products/5mm-curb-chain-18k-gold-20	175	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Gold-Chain-Tile_THUMBNAIL_f4a06de8-954c-4d69-9848-1925be109b14.jpg?v=1777912937	0	2026-05-14 07:21:41.351374	2026-05-07 03:04:49.513294	2026-05-14 07:21:41.367777	Jewelry - Chains - 5mm Curb Chain - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1091	25	Tablet Trio	https://blueland.com/products/tablet-trio-surprise-a	58	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Tablet_Trio_Scented_Final_2026_01.jpg?v=1769809616	0	2026-05-14 07:20:29.694802	2026-04-21 11:26:58.61165	2026-05-14 07:20:29.70508	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1092	25	Signature Hand Soap Starter Set (Bundle)	https://blueland.com/products/hand-soap-starter-set-original-bab	18	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_HS_Single__SignatureClear_Free_Clear_Final_2026_01.jpg?v=1769811550	0	2026-05-14 07:20:29.695356	2026-04-21 11:26:58.611651	2026-05-14 07:20:29.70508	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
487	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/quencher-h2-0-flowstate-tumbler-30-oz-mothers-day	45	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.0FlowStateTumbler30OZ-RoseQuartzBouquets-Front.png?v=1775504577	0	2026-05-07 03:04:43.792918	2026-04-11 08:53:26.444745	2026-05-07 03:04:43.807644	Quencher 30oz	\N	t	f	2026-04-16 10:38:15.108364	0	0	\N	shopify	m004|uncategori|0
488	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/quencher-h2-0-flowstate-tumbler-40-oz-mothers-day	50	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.0FlowStateTumbler40OZ-RoseQuartzBouquets-Front.png?v=1775504574	0	2026-05-07 03:04:43.793802	2026-04-11 08:53:26.444747	2026-05-07 03:04:43.807645	Quencher 40oz	\N	t	f	2026-04-16 10:38:15.112687	0	0	\N	shopify	m004|uncategori|0
489	16	Adventure To-Go Food Jar	https://stanley1913.com/products/adventure-to-go-food-jar-mothers-day	40	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-01-27_TheAdventureTo-GoFoodJar18OZ-WildBlooms-Front.png?v=1775504577	0	2026-05-07 03:04:43.794544	2026-04-11 08:53:26.444748	2026-05-07 03:04:43.807646	normal	\N	t	f	2026-04-16 10:38:15.114762	0	0	\N	shopify	m004|uncategori|0
490	16	The Everyday Suburban Mug	https://stanley1913.com/products/the-everyday-suburban-mug-24-oz-mothers-day	45	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-01-27_TheEverydaySuburbanMug24OZ-WildBlooms-Front.png?v=1775504569	0	2026-05-07 03:04:43.795225	2026-04-11 08:53:26.444748	2026-05-07 03:04:43.807646	Mugs	\N	t	f	2026-04-16 10:38:15.116294	0	0	\N	shopify	m004|uncategori|0
491	16	The Quencher® ProTour Flip Straw Tumbler	https://stanley1913.com/products/quencher-protour-flip-straw-tumbler-30-oz-mothers-day	50	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-01-16_TheQuencherProTourFlipStrawTumbler30OZ-WildBlossoms-Front.png?v=1775504565	0	2026-05-07 03:04:43.79596	2026-04-11 08:53:26.444749	2026-05-07 03:04:43.807646	Protour 30oz	\N	t	f	2026-04-16 10:38:15.117824	0	0	\N	shopify	m004|uncategori|0
1093	25	Dishwasher Detergent Starter Set (Bundle)	https://blueland.com/products/dishwasher-detergent-starter-set-bab	25	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Dish_Free_Clear_Starter_Set_ChromeTin_Final_2026_01.jpg?v=1775756877	0	2026-05-14 07:20:29.695922	2026-04-21 11:26:58.611651	2026-05-14 07:20:29.70508	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1094	25	Oxi Laundry Booster Starter Set (Bundle)	https://blueland.com/products/oxi-laundry-booster-starter-set-bab	18	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Oxi_Spring_Bloom_Starter_Set_Final_2026_01.jpg?v=1771444934	0	2026-05-14 07:20:29.696435	2026-04-21 11:26:58.611651	2026-05-14 07:20:29.70508	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1095	25	Laundry Detergent Starter Set (Bundle)	https://blueland.com/products/laundry-detergent-starter-set-bab	25	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Laundry_Fresh_Dew_Starter_Set_Final_2026_01.jpg?v=1772732616	0	2026-05-14 07:20:29.697058	2026-04-21 11:26:58.611652	2026-05-14 07:20:29.705081	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1096	25	Multi-Surface Cleaner Starter Set (Bundle)	https://blueland.com/products/multi-surface-cleaner-starter-set-bab	16	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Multi_Spray_Final_2026_01.jpg?v=1776448407	0	2026-05-14 07:20:29.697702	2026-04-21 11:26:58.611652	2026-05-14 07:20:29.705081	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
294	6	Eco Starter Set	https://coconutbowls.com/products/ecostarter-set	36.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/1_0683996a-a32a-4ce3-a950-070a10f1678f.jpg?v=1719612455	0	2026-04-21 10:23:12.026179	2026-04-11 06:01:47.027804	2026-04-21 10:23:12.031223	Bundle	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
506	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/quencher-h2-0-flowstate-tumbler-20-oz-picnic	45	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.0FlowStateTumbler20OZ-PeachRosePicnicStripe-Front.png?v=1774558248	0	2026-05-07 03:04:43.805451	2026-04-11 08:53:26.44476	2026-05-07 03:04:43.807651	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
507	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/quencher-h2-0-flowstate-tumbler-30-oz-picnic	50	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.0FlowStateTumbler30OZ-PeachRosePicnicStripe-Front.png?v=1774558246	0	2026-05-07 03:04:43.805977	2026-04-11 08:53:26.444761	2026-05-07 03:04:43.807651	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
508	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/quencher-h2-0-flowstate-tumbler-40-oz-picnic	55	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.0FlowStateTumbler40OZ-PeachRosePicnicStripe-Front.png?v=1774558243	0	2026-05-07 03:04:43.806515	2026-04-11 08:53:26.444762	2026-05-07 03:04:43.807652	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
509	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/quencher-h2-0-flowstate-tumbler-togethxr-20-oz	40	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.0FlowStateTumbler20OZ-TOGETHXRTournamentBlack-Back.png?v=1774648241	0	2026-04-21 10:23:17.588305	2026-04-11 08:53:26.444763	2026-04-21 10:23:17.594224	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
510	16	The Quencher H2.0 Flowstate™ Tumbler	https://stanley1913.com/products/quencher-h2-0-flowstate-tumbler-togethxr-40-oz	55	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherH2.0FlowStateTumbler40OZ-TOGETHXRTournamentBlack-Back.png?v=1774648202	0	2026-04-21 10:23:17.58879	2026-04-11 08:53:26.444763	2026-04-21 10:23:17.594224	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
514	16	Stanley 1913 x Juventus The IceFlow™ Flip Straw 2.0 Tumbler	https://stanley1913.com/products/stanley-1913-x-juventus-iceflow-flip-straw-tumbler	45	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheIceFlowFlipStraw2.0Tumbler30OZ-JuventusCoded-Front.png?v=1773256137	0	2026-04-21 10:23:17.590692	2026-04-11 08:53:26.444775	2026-04-21 10:23:17.594225	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
515	16	Classic Easy Fill Wide Mouth Flask | Stanley Create	https://stanley1913.com/products/classic-easy-fill-wide-mouth-flask-8-oz-sc	38	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/B2B_Web_PNG-Adventure-Pre-Party-Flask-8oz-Hammertone-Green.png?v=1762182048	0	2026-04-21 10:23:17.591113	2026-04-11 08:53:26.444776	2026-04-21 10:23:17.594225	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
516	16	Adventure Stacking Beer Pint | Stanley Create	https://stanley1913.com/products/adventure-stacking-beer-pint-16-oz-sc	20	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/B2B_Web_PNG-TheStay-ChillStackingPint16OZ-Pomelo-Front_adffe424-a6ea-4468-9990-b2740f2c66e2.png?v=1762182048	0	2026-04-21 10:23:17.59165	2026-04-11 08:53:26.444777	2026-04-21 10:23:17.594226	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1103	25	1 Year of Toilet Bowl Cleaner	https://blueland.com/products/1-year-of-toilet-cleaner	53	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/PLP_DTC_AnnualBundles_Toilet_PeppermintEucalyptus_Finals_2026.jpg?v=1771444748	0	2026-05-14 07:20:29.701597	2026-04-21 11:26:58.611655	2026-05-14 07:20:29.705082	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1106	25	Laundry Detergent & Toilet Bowl Cleaner Duo	https://blueland.com/products/laundry-toilet-duo	43	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Toilet_Laundry_Unscented_Final_2026_01.jpg?v=1769810388	0	2026-05-14 07:20:29.702969	2026-04-21 11:26:58.611656	2026-05-14 07:20:29.705083	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1107	25	Dishwasher Detergent & Toilet Bowl Cleaner Duo	https://blueland.com/products/dishwasher-toilet-duo	43	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Toilet_Dish_Final_2026_01.jpg?v=1769810281	0	2026-05-14 07:20:29.703372	2026-04-21 11:26:58.611657	2026-05-14 07:20:29.705083	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1108	25	Tablet Trio	https://blueland.com/products/the-tablet-trio	58	USD	https://cdn.shopify.com/s/files/1/0057/9158/0227/files/Carousel_DTC_Tablet_Trio_Scented_Final_2026_01.jpg?v=1769809616	0	2026-05-14 07:20:29.703948	2026-04-21 11:26:58.611657	2026-05-14 07:20:29.705083	Starter Kits	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1207	37	Ridge Keychain - Heritage	https://ridge.com/products/everyday-keychain-heritage	35	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Heritage-Keychain-THUMBNAIL_d1a6b499-22d6-4fb1-8f59-cf3fe411937c.jpg?v=1776986032	0	2026-05-14 07:21:41.365349	2026-05-07 03:04:49.513296	2026-05-14 07:21:41.368651	EDC - Key Accessories - Ridge Keychain - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
754	38	Black Septarian Freeform Flats - 1 of a Kind	https://tinyrituals.co/products/black-septarian-freeform-flat	275	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFLAT-SEPT-MI-1-2.jpg?v=1775660956	0	2026-05-14 07:21:51.426052	2026-04-16 10:29:17.594865	2026-05-14 07:21:51.432553	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
755	38	Rare Septarian Rhyolite Teardrop Pendant Necklace	https://tinyrituals.co/products/septarian-rhyolite-teardrop-pendant-necklace	275	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-SPR-1-12-RJ.jpg?v=1750973817	0	2026-05-14 07:21:51.426418	2026-04-16 10:29:17.594865	2026-05-14 07:21:51.432553	Necklace	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
295	6	Kids Smiles Coconut Bowls	https://coconutbowls.com/products/kids-smiles-coconut-bowl	7.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/2_1c1d90eb-d220-4fb3-8591-d54cb5e87618.jpg?v=1685938490	0	2026-04-21 10:23:12.027017	2026-04-11 06:01:47.027805	2026-04-21 10:23:12.031223	Coconut Bowl	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
296	6	Kids Rainbow Coconut Bowls	https://coconutbowls.com/products/kids-rainbow-coconut-bowl	7.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/8_d8b1ad56-62c5-40b2-a429-fb3b12e56ed6.jpg?v=1685938501	0	2026-04-21 10:23:12.027746	2026-04-11 06:01:47.027805	2026-04-21 10:23:12.031223	Coconut Bowl	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
297	6	Kids Wooden Splash Forks	https://coconutbowls.com/products/kids-wooden-splash-fork	4.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/KidswoodenSplashForks.gif?v=1684885645	0	2026-04-21 10:23:12.028274	2026-04-11 06:01:47.027805	2026-04-21 10:23:12.031223	Accessories	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
298	6	Kids Wooden Splash Spoons	https://coconutbowls.com/products/kids-wooden-splash-spoon	4.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/KidsWoodenSplashSpoons.gif?v=1684885097	0	2026-04-21 10:23:12.028973	2026-04-11 06:01:47.027806	2026-04-21 10:23:12.031223	Accessories	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
866	31	Laptop Dock (Copy)	https://oakywood.shop/products/laptop-dock-copy	87	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/032.jpg?v=1762439572	0	2026-05-14 07:20:34.514369	2026-04-16 10:29:26.740176	2026-05-14 07:20:34.519761	Charging dock	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
168	8	Vesuvianite Stone	https://energymuse.com/products/vesuvianite-stone	14.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/VesuvianiteTumbledStone.png?v=1741807833	0	2026-04-16 10:38:49.657803	2026-04-10 10:30:59.100383	2026-04-16 10:38:49.658562	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
1204	37	Ridge Check-In - MKBHD	https://ridge.com/products/check-in-mkbhd	375	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Travel-CheckIn-MKBHD-THUMB.jpg?v=1741026310	0	2026-05-14 07:21:41.364281	2026-05-07 03:04:49.513294	2026-05-15 05:09:37.010697	TRAVEL - LUGGAGE - CHECK-IN - SINGLE	\N	f	f	\N	0	0	culture	shopify	backfill
1205	37	Ridge Wallet - Forged Aurora	https://ridge.com/products/forged-aurora	76	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/WALLET_THUMBNAIL_469e5d1d-8d0e-4aa6-8003-6ee243a584ba.jpg?v=1698064910	0	2026-05-14 07:21:41.364669	2026-05-07 03:04:49.513295	2026-05-15 05:09:37.010697	EDC - WALLET - RIDGE WALLET - SINGLE	\N	f	f	\N	0	0	culture	shopify	backfill
870	31	Felt MacBook Sleeve (Outlet)	https://oakywood.shop/products/felt-macbook-sleeve-outlet	57	USD	https://cdn.shopify.com/s/files/1/2447/0423/products/IMG_0036mniejsze.jpg?v=1762439835	0	2026-05-14 07:20:34.515895	2026-04-16 10:29:26.740177	2026-05-14 07:20:34.519762	outlet	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
696	33	Offer - CurrentBody Skin Hydrogel Face Mask (10 Pack)	https://currentbody.com/products/currentbody-hydrogel-masks-10-pack-offer	79.9	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/CurrentBody_Skin_Hydrogel_Face_Mask_-_10_PACK.png?v=1774944955	0	2026-05-07 03:05:41.82073	2026-04-16 10:29:11.565065	2026-05-07 03:05:41.842805	Skincare	\N	t	t	\N	0	0	beauty	shopify	m004|keyword_ma|80
633	21	Linen Easy Short | Black	https://everlane.com/products/mens-linen-easy-short-black-2	88	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/5c4afc07_0ab7.jpg?v=1775682007	0	2026-04-16 10:38:40.036132	2026-04-16 10:29:07.014611	2026-04-16 10:38:40.048704	algolia-ignore	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
634	21	Canvas Lug Tote | Golden Brown	https://everlane.com/products/womens-lug-large-canvas-tote-bag-golden-brown	228	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/ab46196a_ca40.jpg?v=1768939208	0	2026-04-16 10:38:40.036596	2026-04-16 10:29:07.014611	2026-04-16 10:38:40.048704	Bags	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
635	21	Canvas Mini Lug Tote | Birch	https://everlane.com/products/womens-lug-mini-canvas-tote-bag-birch	168	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/3ee6b25d_776f.jpg?v=1768939209	0	2026-05-14 07:21:14.123114	2026-04-16 10:29:07.014612	2026-05-14 07:21:14.132529	Bags	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
638	21	Tie-Front Scallop Tank in Linen | Bone	https://everlane.com/products/womens-tie-front-scallop-tank-in-linen-bone	78	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/39f1df43_7a80.jpg?v=1775073603	0	2026-04-16 10:38:40.038406	2026-04-16 10:29:07.014614	2026-04-16 10:38:40.048705	Woven Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
639	21	Tie-Front Scallop Tank in Linen | Henna Red	https://everlane.com/products/womens-tie-front-scallop-tank-in-linen-henna-red	78	USD	https://cdn.shopify.com/s/files/1/0623/7916/3734/files/7cb69082_bc57.jpg?v=1775077203	0	2026-04-16 10:38:40.038838	2026-04-16 10:29:07.014614	2026-04-16 10:38:40.048705	Woven Tops	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
703	33	CurrentBody Wellness Sauna Blanket & Recovery Boots	https://currentbody.com/products/currentbody-wellness-recovery-boots-sauna-blanket	1160.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/CurrentBody_Skin_Sauna_Blanket_and_recovery_boot_bundle_image_1.png?v=1769786272	0	2026-05-07 03:05:41.827434	2026-04-16 10:29:11.565068	2026-05-07 03:05:41.842807	Wellness	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
868	31	Standing Desk Pro Battery	https://oakywood.shop/products/standing-desk-pro-battery	219	USD	https://cdn.shopify.com/s/files/1/2447/0423/files/2.webp?v=1758716996	0	2026-05-14 07:20:34.51513	2026-04-16 10:29:26.740177	2026-05-15 05:09:37.010697	all	\N	t	t	\N	0	0	culture	shopify	backfill
706	33	CurrentBody Skin Eyebrow Precision	https://currentbody.com/products/currentbody-skin-eyebrow-precision	14.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/products/CBD-CBSEB01_GL-ECM-001_92a768a5-f71a-4702-9bc9-e85e57ab9f91.jpg?v=1684487944	0	2026-04-22 04:19:04.386134	2026-04-16 10:29:11.56507	2026-05-15 05:09:37.010697	Device	\N	t	t	\N	0	0	beauty	shopify	backfill
705	33	CurrentBody Skin LED Face & Hair Kit - Black Friday Exclusive	https://currentbody.com/products/currentbody-skin-led-face-hair-kit-pr-offer	945.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/hair_led_kit.jpg?v=1775834316	0	2026-05-14 07:21:16.381169	2026-04-16 10:29:11.565069	2026-05-14 07:21:16.388329	PR	\N	t	t	\N	0	0	beauty-hair	shopify	m004|keyword_ma|80
1036	33	CurrentBody Wellness Infrared PEMF Mat	https://currentbody.com/products/currentbody-wellness-infrared-pemf-mat	1199.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/currentbody-skin-pemf-mat-1.jpg?v=1773246957	0	2026-05-07 03:05:41.837371	2026-04-21 10:23:00.148608	2026-05-07 03:05:41.84281	Wellness	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
331	5	KORE Manuka MGO83+ (250g)	https://thekarelab.com/products/kore-manuka-mgo83-250g	248	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo83-250g-260493.png?v=1668266679	0	2026-05-14 07:20:27.755713	2026-04-11 06:27:34.217639	2026-05-14 07:20:27.777398	health supplement	\N	t	\N	\N	0	0	health	shopify	m004|keyword_ma|80
332	5	KORE Manuka MGO60+ (10g x 30)	https://thekarelab.com/products/kore-manuka-mgo60-10g-x-30	368	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo60-10g-x-30-664614.jpg?v=1668526705	0	2026-05-14 07:20:27.761186	2026-04-11 06:27:34.217641	2026-05-14 07:20:27.777399	b2c_product	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
333	5	KORE Manuka MGO263+ (250g)	https://thekarelab.com/products/kore-manuka-mgo263-250g	388	USD	https://cdn.shopify.com/s/files/1/0490/1447/2862/products/kore-manuka-mgo263-250g-675499.png?v=1668526708	0	2026-05-14 07:20:27.762014	2026-04-11 06:27:34.217641	2026-05-14 07:20:27.777399	b2c_product	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
1037	33	CurrentBody Wellness Leg Recovery Compression Boots	https://currentbody.com/products/currentbody-wellness-leg-recovery-compression-boots	739.99	USD	https://cdn.shopify.com/s/files/1/3097/7858/files/currentbody-skin-recovery-boots-1.jpg?v=1767790743	0	2026-05-07 03:05:41.838092	2026-04-21 10:23:00.148609	2026-05-07 03:05:41.842811	Wellness	\N	t	t	\N	0	0	health	shopify	m004|keyword_ma|80
750	38	Black Septarian Palm Stone - AAA Premium Quality	https://tinyrituals.co/products/black-septarian-palm-stone	38	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/Small-swatch.jpg?v=1775660322	0	2026-05-14 07:21:51.42451	2026-04-16 10:29:17.594862	2026-05-14 07:21:51.432552	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
751	38	Black Septarian Freeform Tower - 1 of a Kind	https://tinyrituals.co/products/black-septarian-freeform-tower	98	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFT-SEPT-MI-1-2.jpg?v=1775660083	0	2026-05-14 07:21:51.424879	2026-04-16 10:29:17.594863	2026-05-14 07:21:51.432552	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
752	38	Rare Black Septarian Crystal Bowl - 1 of a Kind	https://tinyrituals.co/products/black-septarian-bowls	178	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-SEPTBOWL-MI-8-2.jpg?v=1775558265	0	2026-05-14 07:21:51.425257	2026-04-16 10:29:17.594864	2026-05-14 07:21:51.432552	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
753	38	Rare Black Septarian Geode Freeform Crystal - 1 of a Kind	https://tinyrituals.co/products/black-septarian-freeform	178	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FF-Sept-MI-6-1.jpg?v=1774655323	0	2026-05-14 07:21:51.425696	2026-04-16 10:29:17.594864	2026-05-14 07:21:51.432553	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
758	38	Rare Black Septarian Heart Bowl - 1 of a Kind	https://tinyrituals.co/products/black-septarian-heart-bowl	178	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-HBOWL-SEPT-MI-1-7.jpg?v=1774395734	0	2026-05-14 07:21:51.427496	2026-04-16 10:29:17.594867	2026-05-14 07:21:51.432553	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
759	38	Black Obsidian Inclusion Freeform Tower - 1 of a Kind	https://tinyrituals.co/products/rare-black-obsidian-inclusion-tower	58	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFT-BOBI-MI-1-1.jpg?v=1774308733	0	2026-05-14 07:21:51.427837	2026-04-16 10:29:17.594867	2026-05-14 07:21:51.432554	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
760	38	Black Opal Palm Stone - 1 of a Kind	https://tinyrituals.co/products/black-opal-palm-stone	38	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-PS-BOPL-MI-S_7291de09-c691-4378-92d2-4c0800d4a489.jpg?v=1774309483	0	2026-05-14 07:21:51.42817	2026-04-16 10:29:17.594868	2026-05-14 07:21:51.432554	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
761	38	Black Opal Freeform Tower - 1 of a Kind	https://tinyrituals.co/products/black-opal-tower	78	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFT-BOPL-MI-1-1.jpg?v=1774387876	0	2026-05-14 07:21:51.428487	2026-04-16 10:29:17.594869	2026-05-14 07:21:51.432554	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
762	38	Black Opal Freeform Crystals- 1 of a Kind	https://tinyrituals.co/products/black-opal-freeform	98	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FF1-BOPL-MI.jpg?v=1774363002	0	2026-05-14 07:21:51.428846	2026-04-16 10:29:17.594869	2026-05-14 07:21:51.432554	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
763	38	Black Moonstone Palm Stone - 1 of a Kind	https://tinyrituals.co/products/black-moonstone-palm-stone	38	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-PS-BMO-MI-S-4.jpg?v=1774498897	0	2026-05-14 07:21:51.429178	2026-04-16 10:29:17.59487	2026-05-14 07:21:51.432554	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
756	38	Tibetan Prayer Wheel Bracelet	https://tinyrituals.co/products/tibetan-prayer-wheel-bracelet	118	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-PWB-TA_4f22ec24-1d1a-4ffe-ac41-b7a1465a1a69.jpg?v=1773973517	0	2026-05-14 07:21:51.426795	2026-04-16 10:29:17.594866	2026-05-14 07:21:51.432553	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
757	38	Rare Black Septarian Heart - 1 of a Kind	https://tinyrituals.co/products/black-septarian-heart	58	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFH-SEPT-MI-S.jpg?v=1774395340	0	2026-05-14 07:21:51.42716	2026-04-16 10:29:17.594866	2026-05-14 07:21:51.432553	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
770	38	Tiger Eye Square Pendant Necklace	https://tinyrituals.co/products/tiger-eye-square-pendant-necklace	98	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/sivana-tiger-eye-square-necklace-15675822407761.jpg?v=1733960813	0	2026-05-14 07:21:51.431531	2026-04-16 10:29:17.594874	2026-05-14 07:21:51.432555	Necklace	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
771	38	Black Spinel Single or Double Strand Necklace	https://tinyrituals.co/products/black-spinel-single-or-double-strand-necklace	148	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-SD240-BLKS.jpg?v=1770939160	0	2026-05-14 07:21:51.431913	2026-04-16 10:29:17.594875	2026-05-14 07:21:51.432556	Necklace	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1212	38	Carnelian Freeform Polygon - 1 of a Kind	https://tinyrituals.co/products/carnelian-freeform-polygon-1-of-a-kind	78	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-POLY-CAR-MI-1.jpg?v=1776669339	0	2026-05-14 07:21:51.420582	2026-05-07 03:05:01.082973	2026-05-14 07:21:51.432556	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1213	38	Clear Quartz Crystal Bowl - 1 of a Kind - Large	https://tinyrituals.co/products/clear-quartz-bowl-large-1-of-a-kind	250	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-BOWL-CLQ-MI-11-1.jpg?v=1776381397	0	2026-05-14 07:21:51.4214	2026-05-07 03:05:01.082974	2026-05-14 07:21:51.432556	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1214	38	Carnelian Hearts - 1 of a Kind	https://tinyrituals.co/products/carnelian-heart	58	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-FFH-CAR-MI-S-1.jpg?v=1776116205	0	2026-05-14 07:21:51.421964	2026-05-07 03:05:01.082974	2026-05-14 07:21:51.432557	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
1215	38	Garnet Pyramid	https://tinyrituals.co/products/garnet-pyramid	68	USD	https://cdn.shopify.com/s/files/1/0273/4214/3566/files/TR-BCP-GAR-M-1.jpg?v=1777501400	0	2026-05-14 07:21:51.422428	2026-05-07 03:05:01.082975	2026-05-14 07:21:51.432557	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
607	34	LINNER Saturn 2 OTC Hearing Aids	https://linnerlife.com/products/saturn-2-ha	199.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Saturn2__02.jpg?v=1742351137	0	2026-05-14 07:21:55.805925	2026-04-16 10:29:04.554703	2026-05-14 07:21:55.816288	Linner	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
610	34	LINNER Clarity OTC Hearing Aids - Black	https://linnerlife.com/products/linner-clarity-otc-hearing-aids-black	299.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/1_7_11zon.webp?v=1763104557	0	2026-05-14 07:21:55.807532	2026-04-16 10:29:04.554704	2026-05-14 07:21:55.816289	Linner	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
157	8	Copper Ore Slab	https://energymuse.com/products/copper-ore-slab	74.91	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/CopperOreSlab_2.png?v=1774982559	0	2026-04-21 10:23:08.870962	2026-04-10 10:30:59.100378	2026-04-21 10:23:08.88095	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
611	34	LINNER Saturn OTC Hearing Aids - White	https://linnerlife.com/products/linner-saturn-otc-hearing-aids-white	139.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/1_1_92038ebf-56a2-4a31-8a23-3e984c9e5f7a.png?v=1753923921	0	2026-05-14 07:21:55.808098	2026-04-16 10:29:04.554705	2026-05-14 07:21:55.816289	Linner	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
612	34	LINNER Saturn 1 OTC Hearing Aids	https://linnerlife.com/products/linner-saturn-1-otc-hearing-aids	169.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/1_81ae9a65-7db3-498f-b856-fbb4b93878a0.png?v=1774429460	0	2026-05-14 07:21:55.808472	2026-04-16 10:29:04.554705	2026-05-14 07:21:55.816289	Linner	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
617	34	Linner Saturn OTC Hearing Aids [FSA & HSA Eligible]	https://linnerlife.com/products/linner-saturn-hearing-aids	99.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/LINNER-Saturn-Hearing-Aids-Linner-206321230.webp?v=1756780425	0	2026-05-14 07:21:55.811143	2026-04-16 10:29:04.554707	2026-05-14 07:21:55.81629	Linner	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
620	34	LINNER Clarity OTC Hearing Aids	https://linnerlife.com/products/linner-clarity-otc-hearing-aids	299.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/img_v3_02vt_79d08206-948c-4193-9dd3-91e0c4266fcg.png?v=1773802355	0	2026-05-14 07:21:55.812471	2026-04-16 10:29:04.554709	2026-05-14 07:21:55.81629	Linner	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
625	34	Linner Saturn Series mini-CIC OTC Hearing Aids	https://linnerlife.com/products/linner-saturn-otc-hearing-aids	129.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Saturn_2_muse_black.webp?v=1756780425	0	2026-05-14 07:21:55.814469	2026-04-16 10:29:04.554711	2026-05-14 07:21:55.816291	aids	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
626	34	Linner Mercury mini-RIC OTC Hearing Aids	https://linnerlife.com/products/linner-mercury-otc-hearing-aids	229.99	USD	https://cdn.shopify.com/s/files/1/0610/0602/0765/files/Linner-Mercury-Clarity-OTC-Hearing-Aids-_FSA-_-HSA-Eligible_-Linner-110038953.webp?v=1725853434	0	2026-05-14 07:21:55.814855	2026-04-16 10:29:04.554712	2026-05-14 07:21:55.816291	aids	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
151	8	Dumortierite Merkaba Crystala	https://energymuse.com/products/dumortierite-merkaba-crystala	18.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/DumortieriteMerkaba.png?v=1775597717	0	2026-04-21 10:23:08.866431	2026-04-10 10:30:59.100374	2026-04-21 10:23:08.87857	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
152	8	Rose Quartz Faceted Flame	https://energymuse.com/products/rose-quartz-faceted-flame	63.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/RoseQuartzFacetedFlame.png?v=1775497501	0	2026-04-21 10:23:08.867082	2026-04-10 10:30:59.100376	2026-04-21 10:23:08.878571	Crystals	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
153	8	Caribbean Calcite Flame	https://energymuse.com/products/caribbean-calcite-flame	33.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/CaribbeanCalciteFlame.png?v=1775497628	0	2026-04-21 10:23:08.867802	2026-04-10 10:30:59.100376	2026-04-21 10:23:08.878572	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
154	8	Amethyst Cluster on Copper Stand	https://energymuse.com/products/amethyst-cluster-on-copper-stand	26.16	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/AmethystClusteronCopperStand.png?v=1775161281	0	2026-04-21 10:23:08.868559	2026-04-10 10:30:59.100377	2026-04-21 10:23:08.878572	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
155	8	Dream Coat Lemurian Crystal	https://energymuse.com/products/dream-coat-lemurian-crystal	18.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/DreamcoatAmethystCrystal.png?v=1775157942	0	2026-04-21 10:23:08.869306	2026-04-10 10:30:59.100377	2026-04-21 10:23:08.880418	5D	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
156	8	Diamantina Etched Quartz Point	https://energymuse.com/products/diamantina-etched-quartz-point	14.16	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/DiamantinaEtchedQuartzPoint.png?v=1775151758	0	2026-04-21 10:23:08.87012	2026-04-10 10:30:59.100378	2026-04-21 10:23:08.880949	Crystals	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
158	8	AA-grade Durango Fluorite Freeform	https://energymuse.com/products/aa-grade-durango-fluorite-freeform	59.16	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/AA-gradeDurangoFluoriteFreeform_2.png?v=1774896360	0	2026-04-21 10:23:08.871637	2026-04-10 10:30:59.100378	2026-04-21 10:23:08.88095	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
159	8	Purple Fluorite Flower	https://energymuse.com/products/purple-fluorite-flower	74.91	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/PurpleFluoriteFlower.png?v=1774896185	0	2026-04-21 10:23:08.872307	2026-04-10 10:30:59.100379	2026-04-21 10:23:08.88095	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
160	8	Selenite with Hematite Inclusions	https://energymuse.com/products/selenite-with-hematite	36.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/SelenitewithHematiteInclusions.png?v=1774642441	0	2026-04-21 10:23:08.872896	2026-04-10 10:30:59.100379	2026-04-21 10:23:08.88095	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
161	8	Red Phantom Selenite	https://energymuse.com/products/red-phantom-selenite	59.16	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/RedPhantomSelenite.png?v=1774642563	0	2026-04-21 10:23:08.873532	2026-04-10 10:30:59.10038	2026-04-21 10:23:08.880951	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
162	8	Black Phantom Selenite	https://energymuse.com/products/black-phantom-selenite	38.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/BlackPhantomSelenite.png?v=1774642686	0	2026-04-21 10:23:08.874082	2026-04-10 10:30:59.10038	2026-04-21 10:23:08.882431	Crystals	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
163	8	Purpurite Point	https://energymuse.com/products/purpurite-point	33.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/PurpuritePoint.png?v=1774550513	0	2026-04-21 10:23:08.874671	2026-04-10 10:30:59.10038	2026-04-21 10:23:08.882958	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
164	8	The Lemurian Tide Bracelet	https://energymuse.com/products/the-lemurian-tide-bracelet	36.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/TheLemurianTideBracelet.png?v=1774484813	0	2026-04-21 10:23:08.875304	2026-04-10 10:30:59.100381	2026-04-21 10:23:08.882958	Jewelry	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
165	8	The Atlantean Archive Bracelet	https://energymuse.com/products/the-atlantean-archive-bracelet	36.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/TheAtlanteanArchiveBracelet.png?v=1774484792	0	2026-04-21 10:23:08.875863	2026-04-10 10:30:59.100381	2026-04-21 10:23:08.882959	Jewelry	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
166	8	The Earth Anchor Bracelet	https://energymuse.com/products/the-earth-anchor-bracelet	36.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/TheEarthAnchorBracelet.png?v=1774484766	0	2026-04-21 10:23:08.876446	2026-04-10 10:30:59.100382	2026-04-21 10:23:08.882959	Jewelry	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
167	8	Clear Quartz Pillar Light	https://energymuse.com/products/clear-quartz-pillar-light	129.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/2a7c8e7cd1e44fe9a7deccaf46c0244esuperresolution.jpg?v=1774557004	0	2026-04-21 10:23:08.877143	2026-04-10 10:30:59.100382	2026-04-21 10:23:08.884201	Home Decor	\N	t	\N	\N	0	0	culture	shopify	m004|keyword_ma|80
395	8	Financial Transformer Necklace	https://energymuse.com/products/financial-transformer-necklace	188.88	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/MalachitePendantNecklace_1.png?v=1775762294	0	2026-04-21 10:23:08.863668	2026-04-11 06:31:33.8497	2026-04-21 10:23:08.884203	Jewelry	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
396	8	Blue Onyx Sphere	https://energymuse.com/products/blue-onyx-sphere	41.16	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/BlueOnyxSphere.png?v=1775758054	0	2026-04-21 10:23:08.864807	2026-04-11 06:31:33.8497	2026-04-21 10:23:08.885106	Crystals	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
1005	8	Angel Phantom Quartz Crystal	https://energymuse.com/products/angel-phantom-quartz-crystal	21.66	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/AngelPhantomQuartzCrystal_1.png?v=1776103320	0	2026-04-21 10:23:08.857431	2026-04-16 10:38:12.454398	2026-04-21 10:23:08.887971	Crystals	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
1045	8	7.83Hz Frequency Necklace	https://energymuse.com/products/7-83hz-frequency-necklace	101.16	USD	https://cdn.shopify.com/s/files/1/0159/0942/1110/files/7.83HzFrequencyNecklace_2.png?v=1776661366	0	2026-04-21 10:23:08.843411	2026-04-21 10:23:08.888733	2026-04-21 10:23:08.888733	Jewelry	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
458	15	Yin + Yang Duo	https://elixhealing.com/products/yin-yang-duo	69	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/yang-time-focus-productivity-yin-time-sleep_563712c9-a09f-434e-b8b1-6eae65e87d29.webp?v=1773856134	0	2026-04-21 10:23:09.19374	2026-04-11 08:50:45.100932	2026-04-21 10:23:09.2358	ingredient: Ginger	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
459	15	Bloom + Balance (Free Gift!)	https://elixhealing.com/products/stress-less-acu-socks-free-gift-copy	0	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/Bloom_and_Balance_2_8a26afaf-31d9-4a3e-b229-d1ffc8e5bda7.png?v=1770677785	0	2026-04-21 10:23:09.196753	2026-04-11 08:50:45.100933	2026-04-21 10:23:09.235802	Hidden	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
461	15	Stress Less Acu-socks (Free Gift!)	https://elixhealing.com/products/stress-less-acu-socks-free-gift	0	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/ScreenShot2025-12-01at4.04.19PM_06f35732-e03e-47ec-8c48-68273a3b8f4c.png?v=1764633891	0	2026-04-21 10:23:09.199788	2026-04-11 08:50:45.100935	2026-04-21 10:23:09.235803	Hidden	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
462	15	Socks ONLY	https://elixhealing.com/products/socks-only	12	USD	\N	0	2026-04-21 10:23:09.204627	2026-04-11 08:50:45.100935	2026-04-21 10:23:09.235803	Elix	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
463	15	Stress-Less Duo	https://elixhealing.com/products/stress-less-duo	49	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/ScreenShot2025-11-26at2.06.56PM.png?v=1764194847	0	2026-04-21 10:23:09.206458	2026-04-11 08:50:45.100936	2026-04-21 10:23:09.235803	Elix	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
464	15	Metabolism Duo	https://elixhealing.com/products/metabolism-duo	68	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/20251007_elix_0005.jpg?v=1765321109	0	2026-04-21 10:23:09.20813	2026-04-11 08:50:45.100937	2026-04-21 10:23:09.235804	ingredient: Ginger	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
465	15	Yang Time	https://elixhealing.com/products/yang-time	38	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/yang-time-focus-productivity-mushrooms_testimonial_c959cc55-154b-4dad-89fa-c678269b6a91.webp?v=1773781437	0	2026-04-21 10:23:09.209432	2026-04-11 08:50:45.100937	2026-04-21 10:23:09.235804	ingredient: Ginger	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
466	15	Craving Support	https://elixhealing.com/products/craving-support	38	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/Craving_Support_V2.png?v=1762383307	0	2026-04-21 10:23:09.210589	2026-04-11 08:50:45.100938	2026-04-21 10:23:09.235804	ingredient: Ginger	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
468	15	Sleep + Stress Duo	https://elixhealing.com/products/the-sleep-stress-duo	70	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/Sleep_and_Stress_Duo_4bb03611-9f02-42e2-b0d0-ad668c01665c.png?v=1765820884	0	2026-04-21 10:23:09.212793	2026-04-11 08:50:45.100939	2026-04-21 10:23:09.235805	ingredient: Angelica Sinensis	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
470	15	Daily Harmony (3 Bottles)	https://elixhealing.com/products/daily-harmony-3-bottles	96.9	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/products/ElixHealing_Bottle_DailyHarmony_3.png?v=1660768404	0	2026-04-21 10:23:09.214945	2026-04-11 08:50:45.100941	2026-04-21 10:23:09.235805	Elix	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
471	15	Meridian Massager	https://elixhealing.com/products/meridian-massager	48	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/20250421_elix_omm_0008.jpg?v=1746550587	0	2026-04-21 10:23:09.215919	2026-04-11 08:50:45.100941	2026-04-21 10:23:09.235805	ingredient: Angelica Sinensis	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
472	15	Acu-wand	https://elixhealing.com/products/acu-wand	38	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/20250421_elix_omm_0014.jpg?v=1746476953	0	2026-04-21 10:23:09.217248	2026-04-11 08:50:45.100942	2026-04-21 10:23:09.235805	ingredient: Angelica Sinensis	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
473	15	Cycle Balance Quarterly Double Dose	https://elixhealing.com/products/cycle-balance-quarterly-double-dose-1	208.8	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/ElixHealing_Bottle_CycleBalance_1_ea4d81f2-6001-4780-8fbe-c064a4a74faa.png?v=1715186605	0	2026-04-21 10:23:09.218531	2026-04-11 08:50:45.100943	2026-04-21 10:23:09.235806	Hidden	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
474	15	Cycle Balance Quarterly Double Dose	https://elixhealing.com/products/cycle-balance-quarterly-double-dose-copy-1	208.8	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/ElixHealing_Bottle_CycleBalance_1_ea4d81f2-6001-4780-8fbe-c064a4a74faa.png?v=1715186605	0	2026-04-21 10:23:09.21996	2026-04-11 08:50:45.100943	2026-04-21 10:23:09.235806	Hidden	\N	t	t	\N	0	0	culture	shopify	m004|keyword_ma|80
479	15	Cycle Balance Double Dose	https://elixhealing.com/products/cycle-balance-3-month-one-time-purple	104.1	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/3_11a3d903-4924-4380-9bfd-c4bcf8b5382b.png?v=1738782235	0	2026-04-21 10:23:09.226539	2026-04-11 08:50:45.100947	2026-04-21 10:23:09.235807	Hidden	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
480	15	Cycle Balance Double Dose	https://elixhealing.com/products/cycle-balance-3-month-one-time-yellow	104.1	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/3_11a3d903-4924-4380-9bfd-c4bcf8b5382b.png?v=1738782235	0	2026-04-21 10:23:09.227713	2026-04-11 08:50:45.100947	2026-04-21 10:23:09.235807	Hidden	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
481	15	Cycle Balance Double Dose	https://elixhealing.com/products/cycle-balance-3-month-one-time-green	104.1	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/3_11a3d903-4924-4380-9bfd-c4bcf8b5382b.png?v=1738782235	0	2026-04-21 10:23:09.228954	2026-04-11 08:50:45.100948	2026-04-21 10:23:09.235808	Hidden	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
482	15	Cycle Balance Double Dose	https://elixhealing.com/products/cycle-balance-3-month-one-time-red	104.1	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/3_11a3d903-4924-4380-9bfd-c4bcf8b5382b.png?v=1738782235	0	2026-04-21 10:23:09.230058	2026-04-11 08:50:45.100949	2026-04-21 10:23:09.235808	Hidden	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
483	15	Yin Time	https://elixhealing.com/products/yin-time	38	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/Yin_Time_4.png?v=1762202851	0	2026-04-21 10:23:09.231203	2026-04-11 08:50:45.10095	2026-04-21 10:23:09.235808	ingredient: Ginger	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
484	15	Elix Ritual Spoon (Free Gift!)	https://elixhealing.com/products/elix-teaspoon-free-gift	0	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/Teaspoonclearoption.png?v=1729015402	0	2026-04-21 10:23:09.232037	2026-04-11 08:50:45.10095	2026-04-21 10:23:09.235808	Hidden	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
485	15	Bloom + Balance	https://elixhealing.com/products/bloom-and-balance	36	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/Bloom_and_Balance_2.png?v=1762280689	0	2026-04-21 10:23:09.233017	2026-04-11 08:50:45.100951	2026-04-21 10:23:09.235809	Elix	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
486	15	Bloom in Harmony Bundle	https://elixhealing.com/products/bloom-in-harmony-bundle	66	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/2_510e3912-14c6-4e5d-934a-4f28cd983cc7.png?v=1730223410	0	2026-04-21 10:23:09.233976	2026-04-11 08:50:45.100952	2026-04-21 10:23:09.235809	ingredient: Angelica Sinensis	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1046	15	Menopause Trio	https://elixhealing.com/products/menopause-trio	97	USD	https://cdn.shopify.com/s/files/1/0280/4203/5284/files/Menopause_Trio_Elix_Daily_Harmony_Yin_Time-Craving_Support_f06e6007-7e74-4f4e-b887-371e31b6c07c.png?v=1776466257	0	2026-04-21 10:23:09.190446	2026-04-21 10:23:09.241365	2026-04-21 10:23:09.241367	ingredient: Ginger	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
518	17	Kiprun Kipride Women's Running Shoes	https://decathlon.com/products/kiprun-kipride-womens-running-shoes-copy	140	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/8997829-001.jpg?v=1774561099	0	2026-04-21 10:23:09.890869	2026-04-11 08:54:53.6313	2026-04-21 10:23:09.933213	Shoes	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
522	17	Quechua 500 Ultra-Compact Camping Chair 2026	https://decathlon.com/products/quechua-500-ultra-compact-camping-chair	69.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_cd2fbbff-f9df-4f72-99f9-0946d938f7b3.jpg?v=1775483129	0	2026-04-21 10:23:09.901158	2026-04-11 08:54:53.631302	2026-04-21 10:23:09.933214	Folding chair	\N	t	t	\N	0	0	beauty-hair	shopify	m004|keyword_ma|80
530	17	Van Rysel Women's Endurance Road Cycling Bib Shorts	https://decathlon.com/products/van-rysel-womens-endurance-road-cycling-bib-shorts	99.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_6635b272-f5db-4b4a-a0c9-ab26c80820a5.jpg?v=1775494143	0	2026-04-21 10:23:09.912477	2026-04-11 08:54:53.631307	2026-04-21 10:23:09.933216	Cycling bib shorts	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
532	17	Van Rysel Adult RCR Road Cycling Shoes	https://decathlon.com/products/van-rysel-adult-rcr-road-cycling-shoes	279	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_d21516ab-bc5e-43cc-b310-5ac10fec7822.jpg?v=1775494103	0	2026-04-21 10:23:09.915087	2026-04-11 08:54:53.631308	2026-04-21 10:23:09.933216	Cycling Shoes	\N	t	t	\N	0	0	adult-products	shopify	m004|keyword_ma|80
538	17	10L Laptop Backpack	https://decathlon.com/products/10l-laptop-backpack	39.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_564643bd-0656-4809-9e9b-bb74b14b73e1.jpg?v=1775496490	0	2026-04-21 10:23:09.921837	2026-04-11 08:54:53.631312	2026-04-21 10:23:09.933217	Backpack	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
539	17	29L Rolltop Backpack	https://decathlon.com/products/29l-rolltop-backpack-1	89.99	USD	https://cdn.shopify.com/s/files/1/1330/6287/files/default_356517bf-6867-4dc6-a736-69eddf1eaf18.jpg?v=1775496455	0	2026-04-21 10:23:09.923069	2026-04-11 08:54:53.631313	2026-04-21 10:23:09.933218	Backpack	\N	t	t	\N	0	0	women-tops	shopify	m004|keyword_ma|80
1016	9	Golden Dreamcatcher Earrings	https://giva.co/products/dream-catcher-studs	1899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0868_5.jpg?v=1724503542	0	2026-04-21 10:23:10.957417	2026-04-16 10:38:49.170978	2026-04-21 10:23:10.98313	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1047	9	Silver Courage Bracelet For Him	https://giva.co/products/silver-courage-bracelet-for-him	9399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01080_1.jpg?v=1723640834	0	2026-04-21 10:23:10.94881	2026-04-21 10:23:10.984803	2026-04-21 10:23:10.984804	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1049	9	Silver Love in Circles Earrings	https://giva.co/products/silver-love-in-circles-earrings	3399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02570_1.jpg?v=1704369988	0	2026-04-21 10:23:10.952332	2026-04-21 10:23:10.984805	2026-04-21 10:23:10.984805	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1050	9	Golden Alluring Stud Earrings	https://giva.co/products/golden-alluring-stud-earrings	1099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER0599_1.jpg?v=1697119989	0	2026-04-21 10:23:10.953446	2026-04-21 10:23:10.984805	2026-04-21 10:23:10.984805	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1052	9	Silver Studded Zircon Elegance Bracelet	https://giva.co/products/sharpe-shape-stone-bangle	8299	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/BR0476_1.jpg?v=1665665401	0	2026-04-21 10:23:10.956375	2026-04-21 10:23:10.984806	2026-04-21 10:23:10.984816	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1053	9	Silver Inner Confidence Bracelet For Him	https://giva.co/products/silver-inner-confidence-bracelet-for-him	12899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01070_1.jpg?v=1731584497	0	2026-04-21 10:23:10.958339	2026-04-21 10:23:10.984817	2026-04-21 10:23:10.984817	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1054	9	Silver Dazzling Zircon Mangalsutra Bracelet	https://giva.co/products/black-bead-and-stoned-mangalsutra-in-silver-plated	3599	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR0604_1.jpg?v=1703764861	0	2026-04-21 10:23:10.959344	2026-04-21 10:23:10.984818	2026-04-21 10:23:10.984818	Mangalsutra	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1055	9	Silver Royal Blue Drop Bracelet	https://giva.co/products/silver-royal-blue-drop-bracelet	4099	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR0221_1.jpg?v=1694080362	0	2026-04-21 10:23:10.961263	2026-04-21 10:23:10.984818	2026-04-21 10:23:10.984818	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1056	9	Golden Beautiful Moon Hoop Earrings	https://giva.co/products/golden-beautiful-moon-hoop-earrings	2499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02698_1.jpg?v=1738846917	0	2026-04-21 10:23:10.962707	2026-04-21 10:23:10.984818	2026-04-21 10:23:10.984818	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1057	9	Silver Lea Pearl Bracelet	https://giva.co/products/silver-lea-pearl-bracelet	2199	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR01413_1.jpg?v=1773320533	0	2026-04-21 10:23:10.963419	2026-04-21 10:23:10.984819	2026-04-21 10:23:10.984819	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1058	9	Golden Floral Radiance Earrings	https://giva.co/products/golden-floral-radiance-earrings	3999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER01878_1.jpg?v=1706173954	0	2026-04-21 10:23:10.964306	2026-04-21 10:23:10.984819	2026-04-21 10:23:10.984819	Earrings	\N	f	f	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1060	9	Silver Stardust Sparkles Earrings	https://giva.co/products/silver-stardust-sparkles-earrings	1899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/ER02092_1.jpg?v=1692867287	0	2026-04-21 10:23:10.966001	2026-04-21 10:23:10.98482	2026-04-21 10:23:10.98482	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
129	7	Tide Caviar Spoons | Set of 2	https://coreyashford.com/products/caviar-spoon-horn	79	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/caviarr.jpg?v=1760390778	0	2026-04-21 10:23:11.200789	2026-04-10 10:19:59.56014	2026-04-21 10:23:11.21568	Flatware	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1061	9	Oxidised Silver Swastik Rudraksha Bracelet For Him	https://giva.co/products/oxidised-silver-rudraksha-bracelet-for-him	3699	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/TLBR086_1.jpg?v=1765459026	0	2026-04-21 10:23:10.966751	2026-04-21 10:23:10.98482	2026-04-21 10:23:10.98482	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1062	9	Golden Kai Hoop Ear Piercings	https://giva.co/products/golden-kai-hoop-ear-piercings	1899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PER015_1_781c46bf-44b0-499c-b004-38ea39242db6.jpg?v=1750255363	0	2026-04-21 10:23:10.967645	2026-04-21 10:23:10.984821	2026-04-21 10:23:10.984821	Piercing Earring	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1063	9	Elegance On The Rise Necklace	https://giva.co/products/elegance-on-the-rise-necklace	4499	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/PD0478_1.jpg?v=1640960314	0	2026-04-21 10:23:10.96873	2026-04-21 10:23:10.984821	2026-04-21 10:23:10.984821	Pendant	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1067	9	Golden Sylvia Piercing Set	https://giva.co/products/golden-sylvia-piercing-set	4899	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/PER013_PER014_PER015_1_84c3049d-2bbd-4216-b944-8b4e3fca477f.jpg?v=1750257193	0	2026-04-21 10:23:10.972748	2026-04-21 10:23:10.984823	2026-04-21 10:23:10.984823	Piercing Earring	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1069	9	Rose Gold Mesmerising Bangle Bracelet	https://giva.co/products/rose-gold-mesmerising-bangle-bracelet	7999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/BR0844_1.jpg?v=1698930820	0	2026-04-21 10:23:10.975981	2026-04-21 10:23:10.984823	2026-04-21 10:23:10.984824	Bracelet	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
1070	9	Golden Baby Elephant Kids Earrings (4-12 yrs)	https://giva.co/products/kids-elephant-earrings	1399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/products/ER0690_1-min.jpg?v=1661442294	0	2026-04-21 10:23:10.976781	2026-04-21 10:23:10.984824	2026-04-21 10:23:10.984824	Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1073	9	Golden Luminous Zircon Stud For Him	https://giva.co/products/golden-luminous-zircon-stud-for-him	1399	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER0120_1_c9726b75-ffbb-46f4-b4a2-e2a7ccb56023.jpg?v=1770306788	0	2026-04-21 10:23:10.981032	2026-04-21 10:23:10.984825	2026-04-21 10:23:10.984825	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
1074	9	Silver Twilight Spark Stud For Him	https://giva.co/products/silver-twilight-spark-stud-for-him	999	USD	https://cdn.shopify.com/s/files/1/0061/8378/0442/files/MER068_1.jpg?v=1754567035	0	2026-04-21 10:23:10.981978	2026-04-21 10:23:10.984825	2026-04-21 10:23:10.984826	Men's Earrings	\N	t	t	\N	0	0	accessories-jewelry	shopify	m004|keyword_ma|80
139	7	Atlas Incense Dish | Brass	https://coreyashford.com/products/atlas-incense-holder-brass	95	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey_ashford_brass_atlas_dish.jpg?v=1737522656	0	2026-04-21 10:23:11.208005	2026-04-10 10:19:59.560145	2026-04-21 10:23:11.215682	lifestyle	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
140	7	Atlas Bowl | Marble	https://coreyashford.com/products/atlas-bowl-travertine	495	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey_ashford_marble_atlas_bowl_catchall_travertine_stone.jpg?v=1737935143	0	2026-04-21 10:23:11.208669	2026-04-10 10:19:59.560146	2026-04-21 10:23:11.215682	Bowl	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
141	7	Striped Lighter | Silver	https://coreyashford.com/products/striped-lighter-silver	105	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-silver-striped-japanese-lighter.jpg?v=1737595938	0	2026-04-21 10:23:11.209284	2026-04-10 10:19:59.560146	2026-04-21 10:23:11.215683	lifestyle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
142	7	Striped Lighter | Brass	https://coreyashford.com/products/striped-lighter-brass	105	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-gold-striped-japanese-lighter_dc5fa998-c300-4900-8fd6-ca2a68931d7e.jpg?v=1737596373	0	2026-04-21 10:23:11.209912	2026-04-10 10:19:59.560146	2026-04-21 10:23:11.215683	lifestyle	\N	t	t	\N	0	0	women-underwear	shopify	m004|keyword_ma|80
143	7	Slim Lighter | Silver	https://coreyashford.com/products/slim-lighter-silver	65	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-silver-slim-lighter.jpg?v=1737596267	0	2026-04-21 10:23:11.210599	2026-04-10 10:19:59.560147	2026-04-21 10:23:11.215683	lifestyle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
150	7	Canelé Catchall | Marble	https://coreyashford.com/products/canele-catchall-travertine	695	USD	https://cdn.shopify.com/s/files/1/0371/1195/5587/files/corey-ashford-canele-catchall-bianco-marble.jpg?v=1737934649	0	2026-04-21 10:23:11.21465	2026-04-10 10:19:59.560151	2026-04-21 10:23:11.215685	bowl	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
274	6	Rainbow Coconut Bowls	https://coconutbowls.com/products/rainbow-beauty-coconut-bowl	8.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/5_e2e1b91d-8a65-4d0b-b614-9b0c5f82f5af.jpg?v=1685938514	0	2026-04-21 10:23:12.011852	2026-04-11 06:01:47.027797	2026-04-21 10:23:12.031209	Coconut Bowl	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
275	6	Smiles Coconut Bowls	https://coconutbowls.com/products/happiness-coconut-bowl	7.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/5_1ccdc19d-49b1-4ae7-8098-5abfe1144316.jpg?v=1685938523	0	2026-04-21 10:23:12.012603	2026-04-11 06:01:47.027797	2026-04-21 10:23:12.031209	Coconut Bowl	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
276	6	Smiles Kids Bamboo Cup	https://coconutbowls.com/products/smiles-bamboo-cup	8.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/image_Nrd.jpg?v=1708317292	0	2026-04-21 10:23:12.013256	2026-04-11 06:01:47.027797	2026-04-21 10:23:12.031209	Wooden Cup	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
277	6	Yin + Yang Boho Coconut Bowls	https://coconutbowls.com/products/yin-yang-boho-coconut-bowl	8.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/1_14e440f6-44ea-48ae-88bb-eb58655cf1ae.png?v=1637508968	0	2026-04-21 10:23:12.014016	2026-04-11 06:01:47.027798	2026-04-21 10:23:12.03121	Coconut Bowl	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
278	6	Wooden Coconut Cutlery Set	https://coconutbowls.com/products/wooden-coconut-cutlery-set	27.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/2_7f6815ea-e7ea-49dc-a350-743ec358b9bb.jpg?v=1637505810	0	2026-04-21 10:23:12.014879	2026-04-11 06:01:47.027798	2026-04-21 10:23:12.03121	Accessories	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
279	6	Medium Bamboo Cups	https://coconutbowls.com/products/bamboo-cup-medium	7.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/snackx4me_berries_porridge2.jpg?v=1722044284	0	2026-04-21 10:23:12.015638	2026-04-11 06:01:47.027798	2026-04-21 10:23:12.03121	Accessories	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
280	6	Wave Coconut Bowls	https://coconutbowls.com/products/wave-bowl	8.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/7_e56b0317-121b-492f-ab6c-a91a9f79625c.jpg?v=1658980386	0	2026-04-21 10:23:12.016309	2026-04-11 06:01:47.027799	2026-04-21 10:23:12.03121	Coconut Bowl	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
281	6	Van Life Coconut Bowls	https://coconutbowls.com/products/van-life-coconut-bowl	8.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/39.jpg?v=1687145900	0	2026-04-21 10:23:12.017028	2026-04-11 06:01:47.027799	2026-04-21 10:23:12.03121	Coconut Bowl	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
282	6	Sunshine & Rainbows Bamboo Straws - Set of 4	https://coconutbowls.com/products/sunshine-bamboo-straws	5.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/23_1_4b575f8a-f9ce-46a0-9317-4c2f6be1f4b6.jpg?v=1637510204	0	2026-04-21 10:23:12.017689	2026-04-11 06:01:47.0278	2026-04-21 10:23:12.031211	Accessories	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
283	6	Bamboo Straws	https://coconutbowls.com/products/bamboo-straws-1	3.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/alinapetitefijian_mango_smoothie.jpg?v=1722043885	0	2026-04-21 10:23:12.01842	2026-04-11 06:01:47.0278	2026-04-21 10:23:12.031211	Accessories	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
284	6	Wooden Splash Forks	https://coconutbowls.com/products/wooden-splash-fork	5.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/WoodenSplashFork.gif?v=1684883899	0	2026-04-21 10:23:12.019114	2026-04-11 06:01:47.027801	2026-04-21 10:23:12.031211	Accessories	\N	t	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
285	6	Wooden Splash Spoons	https://coconutbowls.com/products/wooden-splash-spoon	5.95	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/WoodenSplashSpoon.gif?v=1684880214	0	2026-04-21 10:23:12.0199	2026-04-11 06:01:47.027801	2026-04-21 10:23:12.031211	Accessories	\N	f	\N	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
286	6	Botanical Citrus Coconut Candle	https://coconutbowls.com/products/botanical-citrus-coconut-candle	22.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/16_0b1b7b4d-230c-47c4-b139-89dfc5d17746.png?v=1707188851	0	2026-04-21 10:23:12.020721	2026-04-11 06:01:47.027801	2026-04-21 10:23:12.031211	Candle	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
287	6	Botanical Lavender Coconut Candle	https://coconutbowls.com/products/botanical-lavendar-coconut-candle	22.47	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/14_ae4aad8e-8cef-4930-8979-1e0b4c48cb9c.png?v=1707188613	0	2026-04-21 10:23:12.021422	2026-04-11 06:01:47.027802	2026-04-21 10:23:12.031211	Candle	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
291	6	Coconut Bowls E-Gift Cards	https://coconutbowls.com/products/coconut-bowls-e-gift-cards	12.5	USD	https://cdn.shopify.com/s/files/1/1426/7088/products/CoconutBowls-GiftCard.jpg?v=1662619707	0	2026-04-21 10:23:12.023856	2026-04-11 06:01:47.027803	2026-04-21 10:23:12.031222	Gift Cards	\N	t	\N	\N	0	0	\N	shopify	m004|uncategori|0
292	6	$50 Mystery Bundle	https://coconutbowls.com/products/50-mystery-bundle-au	50	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/CoconutBowlsLuckyDip50_991e9655-263d-4ee9-a311-779cb5821dbc.gif?v=1697678198	0	2026-04-21 10:23:12.024553	2026-04-11 06:01:47.027803	2026-04-21 10:23:12.031222	Bundle	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
293	6	$100 Mystery Bundle	https://coconutbowls.com/products/100-mystery-bundle-au	100	USD	https://cdn.shopify.com/s/files/1/1426/7088/files/CoconutBowlsLuckyDip100_9624a895-2a07-4ce0-af0d-e3f980d2c08a.gif?v=1697678140	0	2026-04-21 10:23:12.025102	2026-04-11 06:01:47.027804	2026-04-21 10:23:12.031223	Bundle	\N	f	\N	\N	0	0	\N	shopify	m004|uncategori|0
943	26	Custom Pet Photobook	https://crownandpaw.com/products/custom-pet-book	34.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/Covers_On_Bed_Mock_Up_-_Pets.jpg?v=1761317254	0	2026-05-07 03:04:44.484224	2026-04-16 10:29:45.355538	2026-05-07 03:04:44.507395	Books	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
944	26	Custom Modern Pet Portrait Mug - Five Pets	https://crownandpaw.com/products/custom-modern-pet-portrait-mug-five-pets	49.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/5pets.jpg?v=1761903773	0	2026-05-07 03:04:44.485506	2026-04-16 10:29:45.35554	2026-05-07 03:04:44.507396	Mug	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
945	26	Custom Modern Pet Portrait Mug - Six Pets	https://crownandpaw.com/products/custom-modern-pet-portrait-mug-six-pets	49.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/6pets.jpg?v=1761903767	0	2026-05-07 03:04:44.486719	2026-04-16 10:29:45.35554	2026-05-07 03:04:44.507396	Mug	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
966	26	The Sensei - Custom Pet Poster	https://crownandpaw.com/products/the-sensei-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Sensei_-_Framed_Poster_Black_Mock_Up.jpg?v=1756397653	0	2026-05-07 03:04:44.503358	2026-04-16 10:29:45.355549	2026-05-07 03:04:44.507402	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
967	26	The Rock Teacher - Custom Pet Poster	https://crownandpaw.com/products/the-rock-teacher-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Rock_Teacher_-_Framed_Poster_Black_Mock_Up.jpg?v=1756397357	0	2026-05-07 03:04:44.503919	2026-04-16 10:29:45.355549	2026-05-07 03:04:44.507402	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
968	26	The Female Warlock - Custom Pet Poster	https://crownandpaw.com/products/the-female-warlock-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Female_Warlock_-_Framed_Poster_Black_Mock_Up.jpg?v=1756464316	0	2026-05-07 03:04:44.504587	2026-04-16 10:29:45.35555	2026-05-07 03:04:44.507402	Poster	\N	t	t	\N	0	0	women-fashion	shopify	m004|keyword_ma|80
969	26	The Warlock - Custom Pet Poster	https://crownandpaw.com/products/the-warlock-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Warlock_-_Framed_Poster_Black_Mock_Up.jpg?v=1756464151	0	2026-05-07 03:04:44.505269	2026-04-16 10:29:45.35555	2026-05-07 03:04:44.507403	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
970	26	The Marty - Custom Pet Poster	https://crownandpaw.com/products/the-marty-custom-pet-poster	79.95	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/TheMarty-FramedPosterBlackMockUp.jpg?v=1756394965	0	2026-05-07 03:04:44.505959	2026-04-16 10:29:45.355551	2026-05-07 03:04:44.507403	Poster	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
971	26	The Miss Honey - Custom Pet Canvas	https://crownandpaw.com/products/the-miss-honey-custom-pet-canvas	46.86	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Miss_Honey_-_Canvas_on_Floor_Mock_Up.jpg?v=1756397944	0	2026-04-21 10:23:16.091636	2026-04-16 10:29:45.355551	2026-04-21 10:23:16.093648	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
972	26	The Karate Duo - Custom Pet Canvas	https://crownandpaw.com/products/the-karate-duo-custom-pet-canvas	46.86	USD	https://cdn.shopify.com/s/files/1/0052/6198/3830/files/The_Karate_Duo_-_Canvas_on_Floor_Mock_Up.jpg?v=1756397720	0	2026-04-21 10:23:16.092181	2026-04-16 10:29:45.355552	2026-04-21 10:23:16.093648	Canvas	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
496	16	The Stanley 1913 x Nelly Korda Quencher® ProTour Flip Straw Tumbler	https://stanley1913.com/products/stanley-1913-x-nelly-korda-quencher-protour-flip-straw-tumbler	50	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-The_Quencher_ProTour_Flip_Straw_Tumbler_30OZ_-_Nelly_Korda_Pinstripe_-_Front.png?v=1775145875	0	2026-05-07 03:04:43.79931	2026-04-11 08:53:26.444753	2026-05-07 03:04:43.807648	Protour 30oz	\N	t	f	2026-04-21 10:23:17.5816	0	0	\N	shopify	m004|uncategori|0
497	16	The Everyday Can Cooler Cup	https://stanley1913.com/products/everyday-can-cooler-cup-10-oz-picnic	35	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-02-06_TheEverydayCanCoolerCup10OZ-PeachRosePicnicStripe-Front.png?v=1775167899	0	2026-05-07 03:04:43.799993	2026-04-11 08:53:26.444753	2026-05-07 03:04:43.807648	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
498	16	The Reserve Wine Tumbler	https://stanley1913.com/products/reserve-wine-tumbler-11-oz-picnic	35	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-2026-02-06__The_Reserve_Wine_Tumbler_11OZ_-_Rose_Quartz_Rattan_-_Front.png?v=1775149121	0	2026-05-07 03:04:43.800584	2026-04-11 08:53:26.444754	2026-05-07 03:04:43.807649	Barware	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
512	16	Stanley 1913 x Juventus The IceFlow™ Bottle Flip Straw 2.0	https://stanley1913.com/products/stanley-1913-x-juventus-iceflow-bottle-flip-straw	45	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheIceFlowFlipStraw2.0Bottle24OZ-JuventusCoded-Ortho.png?v=1773256776	0	2026-04-21 10:23:17.589775	2026-04-11 08:53:26.444774	2026-04-21 10:23:17.594225	normal	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
513	16	Stanley 1913 x Juventus Quencher® ProTour Flip Straw Tumbler	https://stanley1913.com/products/stanley-1913-x-juventus-quencher-protour-flip-straw-tumbler	50	USD	https://cdn.shopify.com/s/files/1/0375/3269/6635/files/Web_PNG_Square-TheQuencherProTourFlipStrawTumbler30OZ-JuventusCoded-Front.png?v=1773256484	0	2026-04-21 10:23:17.590226	2026-04-11 08:53:26.444775	2026-04-21 10:23:17.594225	Protour 30oz	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
887	28	Custom Men’s Cologne Set	https://beardbrand.com/products/custom-mens-cologne-set	140	USD	https://cdn.shopify.com/s/files/1/0209/0478/files/edps_8_brown.jpg?v=1774905624	0	2026-05-14 07:21:46.906515	2026-04-16 10:29:28.091188	2026-05-14 07:21:46.915073	Bundles	\N	t	t	\N	0	0	pod-custom	shopify	m004|keyword_ma|80
740	37	2.0 Refresh Set - Forgedfetti	https://ridge.com/products/2-0-refresh-set-forgedfetti	75	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Forgedfetti-Wallet-RenderFront_29011aaf-1b7c-4ee0-a391-554c8eebf783.jpg?v=1772927049	0	2026-04-21 10:23:23.01567	2026-04-16 10:29:16.976848	2026-04-21 10:23:23.020597	EDC - Wallet Accessories - 2.0 Refresh Set - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
741	37	2.0 Refresh Set - Basecamp Orange	https://ridge.com/products/2-0-refresh-set-basecamp-orange	45	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/BasecampOrange-Wallet-RenderFront.jpg?v=1772927015	0	2026-04-21 10:23:23.016265	2026-04-16 10:29:16.976848	2026-04-21 10:23:23.020598	EDC - Wallet Accessories - 2.0 Refresh Set - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
742	37	2.0 Refresh Set - Matte Olive	https://ridge.com/products/2-0-refresh-set-matte-olive	45	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/MatteOlive-Wallet-RenderFront.jpg?v=1772926961	0	2026-04-21 10:23:23.016879	2026-04-16 10:29:16.976849	2026-04-21 10:23:23.020598	EDC - Wallet Accessories - 2.0 Refresh Set - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
743	37	2.0 Refresh Set - At The Turn	https://ridge.com/products/2-0-refresh-set-at-the-turn	55	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/AttheTurn-Wallet-RenderFront.jpg?v=1772931498	0	2026-04-21 10:23:23.017561	2026-04-16 10:29:16.97685	2026-04-21 10:23:23.020598	EDC - Wallet Accessories - 2.0 Refresh Set - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
744	37	Multi-Tool - Titanium	https://ridge.com/products/multi-tool-titanium	45	USD	https://cdn.shopify.com/s/files/1/0613/6213/files/Titanium-Multitool-THUMBNAIL.jpg?v=1772792856	0	2026-04-21 10:23:23.018238	2026-04-16 10:29:16.97685	2026-04-21 10:23:23.020598	EDC - Wallet Accessories - Multi-Tool - SINGLE	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
818	35	Original Turmeric Latte Blend	https://golde.co/products/golde-turmeric-powder	32	USD	https://cdn.shopify.com/s/files/1/1217/2268/products/SuperfoodLatteBlend_OriginalTurmeric_Front_IKH04349.jpg?v=1604785598	0	2026-05-07 03:04:53.780206	2026-04-16 10:29:21.767981	2026-05-07 03:04:53.783184	Cortina	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
819	35	Matcha Turmeric Latte Blend	https://golde.co/products/matcha-turmeric-latte-blend	32	USD	https://cdn.shopify.com/s/files/1/1217/2268/products/SuperfoodLatteBlend_MatchaTurmeric_Front_IKH04353.jpg?v=1604784437	0	2026-05-07 03:04:53.780772	2026-04-16 10:29:21.767981	2026-05-07 03:04:53.783184	Cortina	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
820	35	Cacao Turmeric Latte Blend	https://golde.co/products/cacao-turmeric-latte-blend	32	USD	https://cdn.shopify.com/s/files/1/1217/2268/products/SuperfoodLatteBlend_CacaoTurmeric_Front_IKH04351.jpg?v=1605909842	0	2026-05-07 03:04:53.78143	2026-04-16 10:29:21.767981	2026-05-07 03:04:53.783185	Cortina	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
821	35	Pure Matcha	https://golde.co/products/new-pure-matcha	39	USD	https://cdn.shopify.com/s/files/1/1217/2268/files/PureMatcha40_LifestyleProduct.png?v=1755780699	0	2026-05-07 03:04:53.781931	2026-04-16 10:29:21.767982	2026-05-07 03:04:53.783185	food	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
822	35	Clean Greens Face Mask	https://golde.co/products/clean-greens-anti-pollution-face-mask	34	USD	https://cdn.shopify.com/s/files/1/1217/2268/products/SuperfoodFaceMask_CleanGreens_Front_IKH04366.jpg?v=1644527815	0	2026-05-07 03:04:53.782389	2026-04-16 10:29:21.767982	2026-05-07 03:04:53.783185	beauty	\N	t	t	\N	0	0	beauty	shopify	m004|already_st|100
824	32	Racquet Club Reed Diffuser Refill	https://hotellobbycandle.com/products/racquet-club-reed-diffuser-refill	60	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Diffuser_Refill-_Regular.png?v=1760975263	0	2026-05-07 03:04:53.578059	2026-04-16 10:29:26.176065	2026-05-07 03:04:53.596458	Diffuser	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
825	32	Racquet Club Reed Diffuser	https://hotellobbycandle.com/products/racquet-club-reed-diffuser	74	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/diffuser_png_98029d54-6e11-4daf-ac18-fd79a8845233.png?v=1774976039	0	2026-05-07 03:04:53.57906	2026-04-16 10:29:26.176066	2026-05-07 03:04:53.596458	Diffuser	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
826	32	Racquet Club Gift Set	https://hotellobbycandle.com/products/racquet-club-gift-set	132	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/gift_set_png.png?v=1774967304	0	2026-05-07 03:04:53.579952	2026-04-16 10:29:26.176066	2026-05-07 03:04:53.596459	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
827	32	Racquet Club Candle	https://hotellobbycandle.com/products/racquet-club-candle	58	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/candlepng.png?v=1774975987	0	2026-05-07 03:04:53.58065	2026-04-16 10:29:26.176067	2026-05-07 03:04:53.596459	Candle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
828	32	Fifth Anniversary Signature Candle	https://hotellobbycandle.com/products/fifth-anniversary-candle	120	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/5thAnny-Regular.png?v=1765909123	0	2026-05-07 03:04:53.581208	2026-04-16 10:29:26.176068	2026-05-07 03:04:53.596459	Candle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
829	32	Needlepoint Matchbox Duo	https://hotellobbycandle.com/products/needlepoint-matchbox	8	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Needlepoint-Regular_0858b89a-5599-4a5a-b61c-3727d9d4901b.png?v=1765229242	0	2026-05-07 03:04:53.581787	2026-04-16 10:29:26.176068	2026-05-07 03:04:53.596459	Accessories	\N	t	t	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
830	32	Mahjong Matchbox Duo	https://hotellobbycandle.com/products/mahjong-matchbox	8	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Mahjong-Regular_96170ec6-518a-498e-8d33-ab39a2119dd0.png?v=1765229629	0	2026-05-07 03:04:53.582305	2026-04-16 10:29:26.176069	2026-05-07 03:04:53.596459	Accessories	\N	f	f	\N	0	0	fashion-accessories	shopify	m004|keyword_ma|80
831	32	Mahjong Candle	https://hotellobbycandle.com/products/mahjong-candle	58	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Mahjong-Regular_6a9b914e-a3b7-4c02-baae-de5b74e861d3.png?v=1763742391	0	2026-05-07 03:04:53.582876	2026-04-16 10:29:26.176069	2026-05-07 03:04:53.59646	Candle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
832	32	Needlepoint Candle	https://hotellobbycandle.com/products/needlepoint-candle	58	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Needlepoint-Regular.png?v=1763742377	0	2026-05-07 03:04:53.583549	2026-04-16 10:29:26.17607	2026-05-07 03:04:53.59646	Candle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
833	32	The Discovery Set	https://hotellobbycandle.com/products/eau-de-parfum-bundle	165	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/bundleEDP-Regular.png?v=1763070869	0	2026-05-07 03:04:53.584181	2026-04-16 10:29:26.17607	2026-05-07 03:04:53.59646	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
834	32	London Eau de Parfum	https://hotellobbycandle.com/products/london-eau-de-parfum	48	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/LondonEDP-Regular.png?v=1760457101	0	2026-05-07 03:04:53.584875	2026-04-16 10:29:26.176071	2026-05-07 03:04:53.59646	EDP	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
835	32	Signature Eau de Parfum	https://hotellobbycandle.com/products/signature-eau-de-parfum	48	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/SignatureEDP-Regular.png?v=1760457039	0	2026-05-07 03:04:53.585613	2026-04-16 10:29:26.176071	2026-05-07 03:04:53.59646	EDP	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
836	32	Miami Eau de Parfum	https://hotellobbycandle.com/products/miami-eau-de-parfum	48	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/MiamiEDP-Regular.png?v=1760457064	0	2026-05-07 03:04:53.586347	2026-04-16 10:29:26.176072	2026-05-07 03:04:53.596461	EDP	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
837	32	Poolside Eau de Parfum	https://hotellobbycandle.com/products/poolside-eau-de-parfum	48	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/PoolsideEDP-Regular.png?v=1760457081	0	2026-05-07 03:04:53.587033	2026-04-16 10:29:26.176072	2026-05-07 03:04:53.596461	EDP	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
838	32	London Gift Set	https://hotellobbycandle.com/products/london-gift-set	132	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/London_Gift_Set_-_Regular.png?v=1762272734	0	2026-05-07 03:04:53.587791	2026-04-16 10:29:26.176073	2026-05-07 03:04:53.596461	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
839	32	Hamptons Gift Set	https://hotellobbycandle.com/products/hamptons-gift-set	132	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Hamptons_Gift_Set_-_Regular.png?v=1762272798	0	2026-05-07 03:04:53.588391	2026-04-16 10:29:26.176073	2026-05-07 03:04:53.596461	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
840	32	Signature Gift Set	https://hotellobbycandle.com/products/signature-gift-set	132	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Signature_Gift_Set_-_Regular.png?v=1762272776	0	2026-05-07 03:04:53.589026	2026-04-16 10:29:26.176073	2026-05-07 03:04:53.596462	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
841	32	Holiday Gift Set	https://hotellobbycandle.com/products/holiday-gift-set	132	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Holiday_Gift_Set_-_Regular.png?v=1762272753	0	2026-05-07 03:04:53.589593	2026-04-16 10:29:26.176074	2026-05-07 03:04:53.596462	Bundle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
842	32	Holiday Candle	https://hotellobbycandle.com/products/holiday-candle	60	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Holiday-Regular_2.png?v=1762197967	0	2026-05-07 03:04:53.590207	2026-04-16 10:29:26.176075	2026-05-07 03:04:53.596462	Candle	\N	f	f	\N	0	0	\N	shopify	m004|uncategori|0
843	32	Fifth Avenue Candle	https://hotellobbycandle.com/products/fifth-avenue-candle	60	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/5thAve-Regular.png?v=1760457423	0	2026-04-21 10:23:34.995631	2026-04-16 10:29:26.176075	2026-04-21 10:23:34.999611	Candle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
844	32	Prosecco Candle	https://hotellobbycandle.com/products/prosecco-candle	58	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Prosecco-Regular.png?v=1759513282	0	2026-05-07 03:04:53.590832	2026-04-16 10:29:26.176076	2026-05-07 03:04:53.596462	Candle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
845	32	Aspen Reed Diffuser	https://hotellobbycandle.com/products/aspen-reed-diffuser	74	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/AspenDiffuser-Regular_bf378340-f09f-4c1f-b6f6-722c8af2238f.png?v=1757085728	0	2026-05-07 03:04:53.591423	2026-04-16 10:29:26.176076	2026-05-07 03:04:53.596462	Diffuser	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
846	32	Aspen Reed Diffuser Refill	https://hotellobbycandle.com/products/aspen-reed-diffuser-refill	60	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Diffuser_Refill_Transparent.png?v=1762276830	0	2026-05-07 03:04:53.592043	2026-04-16 10:29:26.176077	2026-05-07 03:04:53.596463	Diffuser	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
847	32	Napa Valley Reed Diffuser Refill	https://hotellobbycandle.com/products/napa-valley-reed-diffuser-refill	60	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/Diffuser_Refill_Transparent.png?v=1762276830	0	2026-05-07 03:04:53.592533	2026-04-16 10:29:26.176077	2026-05-07 03:04:53.596463	Diffuser	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
1077	32	Nespresso Candle	https://hotellobbycandle.com/products/nespresso-martini-candle	58	USD	https://cdn.shopify.com/s/files/1/0465/1889/4755/files/nespresso-candle.png?v=1775664356	0	2026-05-07 03:04:53.574451	2026-04-21 10:23:35.003216	2026-05-07 03:04:53.596464	Candle	\N	t	t	\N	0	0	\N	shopify	m004|uncategori|0
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.store (id, name, url, platform, country, status, is_crawling, last_crawl_at, created_at, updated_at, sales_7d, sales_total, platform_code, country_code, data_source, target_country_code, target_category_code, is_manual_reviewed) FROM stdin;
5	The Kare Lab	https://www.thekarelab.com	shopify	us	active	f	2026-05-14 07:20:27.784126	2026-04-07 10:15:45.325179	2026-05-14 07:20:27.785317	0	0	shopify	US	m004|already_st|100	\N	\N	f
21	everlan服饰	https://www.everlane.com	shopify		active	f	2026-05-14 07:21:14.157763	2026-04-16 09:58:11.178098	2026-05-14 07:21:14.15846	0	0	shopify	\N	m004|unknown|0	\N	\N	f
43	测试任务-配置驱动	https://test-task-config.example.com	shopify	\N	active	f	\N	\N	\N	0	0	\N	\N	task_config	US	all	f
24	cowboy运动户外	https://cowboy.com	shopify		active	f	2026-05-14 07:22:11.863096	2026-04-16 10:04:36.200873	2026-05-14 07:22:11.863307	0	0	shopify	\N	m004|unknown|0	\N	sports	f
27	papershootd数码	https://www.papershoot.com	shopify		active	f	2026-05-14 07:20:29.418028	2026-04-16 10:09:16.362994	2026-05-14 07:20:29.418654	0	0	shopify	\N	m004|unknown|0	\N	culture	f
22	yeti户外用品	https://www.yeti.com	shopify		active	f	2026-05-14 07:22:43.501501	2026-04-16 10:01:43.909145	2026-05-14 07:22:43.501757	0	0	shopify	\N	m004|unknown|0	\N	sports	f
23	ritual大健康	https://ritual.com	shopify		active	f	2026-05-14 07:21:14.119494	2026-04-16 10:02:48.882281	2026-05-14 07:21:14.120268	0	0	shopify	\N	m004|unknown|0	\N	health	f
26	crown&paw宠物用品	https://crownandpaw.com	shopify		active	t	2026-05-07 03:04:44.513285	2026-04-16 10:07:17.444975	2026-05-14 07:20:44.070648	0	0	shopify	\N	m004|unknown|0	\N	culture	f
28	beardbrand男士个护	https://www.beardbrand.com	shopify		active	f	2026-05-14 07:21:46.918129	2026-04-16 10:10:38.160444	2026-05-14 07:21:46.918799	0	0	shopify	\N	m004|unknown|0	\N	beauty	f
29	keychron电脑办公	https://www.keychron.com	shopify		active	f	2026-05-14 07:21:29.232985	2026-04-16 10:12:24.802809	2026-05-14 07:21:29.233672	0	0	shopify	\N	m004|unknown|0	\N	culture	f
30	transparent数码	https://transpa.rent/us	shopify		active	f	2026-05-14 07:22:05.564821	2026-04-16 10:14:24.424093	2026-05-14 07:22:05.566293	0	0	shopify	\N	m004|unknown|0	\N	culture	f
31	oakywood电脑办公	https://oakywood.shop	shopify		active	f	2026-05-14 07:20:34.523004	2026-04-16 10:16:19.477914	2026-05-14 07:20:34.523646	0	0	shopify	\N	m004|unknown|0	\N	culture	f
33	currentbody个护	https://www.currentbody.com	shopify		active	f	2026-05-14 07:21:16.392358	2026-04-16 10:19:10.410906	2026-05-14 07:21:16.393152	0	0	shopify	\N	m004|unknown|0	\N	beauty	f
34	linner数码产品	https://www.linnerlife.com	shopify		active	f	2026-05-14 07:21:55.821331	2026-04-16 10:21:21.550657	2026-05-14 07:21:55.82199	0	0	shopify	\N	m004|unknown|0	\N	culture	f
36	lastobject个护	https://lastobject.com	shopify		active	f	2026-05-14 07:20:40.132436	2026-04-16 10:23:55.261921	2026-05-14 07:20:40.133125	0	0	shopify	\N	m004|unknown|0	\N	beauty	f
37	Theridge箱包	https://ridge.com	shopify		active	f	2026-05-14 07:21:41.370792	2026-04-16 10:26:01.211698	2026-05-14 07:21:41.371457	0	0	shopify	\N	m004|unknown|0	\N	culture	f
38	tinyrituals饰品	https://tinyrituals.co	shopify		active	f	2026-05-14 07:21:51.435516	2026-04-16 10:27:40.541219	2026-05-14 07:21:51.436184	0	0	shopify	\N	m004|unknown|0	\N	culture	f
20	vuori clothing服饰	https://vuoriclothing.com	shopify		active	f	2026-05-14 07:21:14.197871	2026-04-16 09:53:38.204694	2026-05-14 07:21:14.198335	0	0	shopify	\N	m004|unknown|0	\N	\N	f
16	stanley1913（水杯）	https://www.stanley1913.com/collections/shop-all	shopify	un	error	f	2026-05-07 03:04:43.816177	2026-04-11 08:53:20.471917	2026-05-14 07:21:42.682337	0	0	shopify	\N	m004|unknown|0	\N	\N	f
46	测试店铺-验证约束	https://test-constraint-verification.example.com	shopify	\N	active	f	\N	2026-05-15 03:46:27.644374	2026-05-15 03:46:27.644375	0	0	\N	\N	task_config	US	beauty	f
47	中式大健康	https://nytrt.com	shopify	US	active	f	2026-05-15 03:52:00.08383	2026-05-15 03:51:52.191674	2026-05-15 03:52:00.085033	0	0	shopify	\N	task_config	\N	health-medical	f
25	blueland家清	https://www.blueland.com	shopify		active	f	2026-05-14 07:20:29.710872	2026-04-16 10:06:07.248318	2026-05-14 07:20:29.711964	0	0	shopify	\N	m004|unknown|0	\N	\N	f
18	发光手机壳	https://lumacases.com	shopify	un	active	f	2026-05-14 07:21:28.132076	2026-04-11 08:55:22.01734	2026-05-14 07:21:28.133156	0	0	shopify	\N	m004|unknown|0	\N	culture	f
32	hotellobbycandle	https://hotellobbycandle.com	shopify		active	f	2026-05-07 03:04:53.600467	2026-04-16 10:17:14.765207	2026-05-07 03:04:53.601566	0	0	shopify	\N	m004|unknown|0	\N	\N	f
35	Golde中药	https://golde.co	shopify		active	f	2026-05-07 03:04:53.786047	2026-04-16 10:22:26.4833	2026-05-07 03:04:53.787003	0	0	shopify	\N	m004|unknown|0	\N	\N	f
8	energymuse（水晶）	https://energymuse.com/collections/crystals	shopify	un	active	f	2026-04-21 10:23:08.890223	2026-04-10 10:30:56.133769	2026-04-21 10:23:08.891261	0	0	shopify	\N	m004|unknown|0	\N	\N	f
15	elixhealing（精油）	https://www.elixhealing.com/	shopify	un	active	f	2026-04-21 10:23:09.24362	2026-04-11 08:50:38.126187	2026-04-21 10:23:09.245545	0	0	shopify	\N	m004|unknown|0	\N	\N	f
7	coreyashford（香炉）	https://coreyashford.com/collections/tableware	shopify	un	active	f	2026-04-21 10:23:11.221049	2026-04-10 10:19:54.433318	2026-04-21 10:23:11.222696	0	0	shopify	\N	m004|unknown|0	\N	\N	f
6	coconutbowls（碗具）	https://www.coconutbowls.com/collections/all	shopify	un	active	f	2026-04-21 10:23:12.037352	2026-04-10 07:06:34.58514	2026-04-21 10:23:12.038813	0	0	shopify	\N	m004|unknown|0	\N	\N	f
9	giva（饰品）	https://www.giva.co/?countryCode=US	shopify	un	active	f	2026-04-21 10:23:10.990883	2026-04-10 10:32:34.147034	2026-04-21 10:23:10.993286	0	0	shopify	\N	m004|unknown|0	\N	culture	f
17	decathlon（户外服饰）	https://www.decathlon.com/	shopify	un	active	f	2026-04-21 10:23:09.94016	2026-04-11 08:54:46.471133	2026-04-21 10:23:09.941971	0	0	shopify	DE	m004|domain_mat|70	\N	sports	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.users (id, username, password_hash, phone, invitation_code, invited_by, created_at, role) FROM stdin;
3	liu	$2b$12$3IcqaEDDr0CnAR5075UXV.DAp/q0sbx0QR2FHzBHRgHvzLxThgfgq	\N	UVHBLB1G	2	2026-04-09 09:56:59.726763+00	user
4	test	$2b$12$BSB3PqsBSnqP3DDuoBWCze3wldsY3oL432fyC9W3DLvMpXqDF63GS	\N	TEST1234	\N	2026-04-11 06:15:34.130478+00	user
2	xiaxia	$2b$12$dKkN8/ckRSP4WHs/Cg5hiu9qg.NShL2kkun/9ZVmRULKuK.IKAsfa	\N	9QSYI78U	\N	2026-04-09 09:41:39.428058+00	admin
\.


--
-- Name: dict_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.dict_category_id_seq', 63, true);


--
-- Name: dict_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.dict_country_id_seq', 15, true);


--
-- Name: dict_platform_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.dict_platform_id_seq', 3, true);


--
-- Name: login_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.login_logs_id_seq', 85, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.product_id_seq', 1296, true);


--
-- Name: store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.store_id_seq', 47, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: dict_category dict_category_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dict_category
    ADD CONSTRAINT dict_category_pkey PRIMARY KEY (id);


--
-- Name: dict_country dict_country_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dict_country
    ADD CONSTRAINT dict_country_pkey PRIMARY KEY (id);


--
-- Name: dict_platform dict_platform_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dict_platform
    ADD CONSTRAINT dict_platform_pkey PRIMARY KEY (id);


--
-- Name: login_logs login_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.login_logs
    ADD CONSTRAINT login_logs_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product product_url_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_url_key UNIQUE (url);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: store store_url_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_url_key UNIQUE (url);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_product_platform_category_sales; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_product_platform_category_sales ON public.product USING btree (platform_code, category_code, sales_7d);


--
-- Name: idx_product_sales_7d_desc; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_product_sales_7d_desc ON public.product USING btree (sales_7d DESC);


--
-- Name: idx_product_sales_total_desc; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_product_sales_total_desc ON public.product USING btree (sales_total DESC);


--
-- Name: idx_product_store_available; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_product_store_available ON public.product USING btree (store_id, is_available);


--
-- Name: idx_store_platform_country_sales; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_store_platform_country_sales ON public.store USING btree (platform_code, country_code, sales_7d);


--
-- Name: idx_store_sales_7d_desc; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_store_sales_7d_desc ON public.store USING btree (sales_7d DESC);


--
-- Name: idx_store_sales_total_desc; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_store_sales_total_desc ON public.store USING btree (sales_total DESC);


--
-- Name: ix_dict_category_code; Type: INDEX; Schema: public; Owner: myuser
--

CREATE UNIQUE INDEX ix_dict_category_code ON public.dict_category USING btree (code);


--
-- Name: ix_dict_category_id; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX ix_dict_category_id ON public.dict_category USING btree (id);


--
-- Name: ix_dict_country_code; Type: INDEX; Schema: public; Owner: myuser
--

CREATE UNIQUE INDEX ix_dict_country_code ON public.dict_country USING btree (code);


--
-- Name: ix_dict_country_id; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX ix_dict_country_id ON public.dict_country USING btree (id);


--
-- Name: ix_dict_platform_code; Type: INDEX; Schema: public; Owner: myuser
--

CREATE UNIQUE INDEX ix_dict_platform_code ON public.dict_platform USING btree (code);


--
-- Name: ix_dict_platform_id; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX ix_dict_platform_id ON public.dict_platform USING btree (id);


--
-- Name: ix_login_logs_id; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX ix_login_logs_id ON public.login_logs USING btree (id);


--
-- Name: ix_product_id; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX ix_product_id ON public.product USING btree (id);


--
-- Name: ix_store_id; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX ix_store_id ON public.store USING btree (id);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_users_invitation_code; Type: INDEX; Schema: public; Owner: myuser
--

CREATE UNIQUE INDEX ix_users_invitation_code ON public.users USING btree (invitation_code);


--
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: myuser
--

CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);


--
-- Name: dict_category dict_category_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dict_category
    ADD CONSTRAINT dict_category_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.dict_category(id);


--
-- Name: product fk_product_category; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_category FOREIGN KEY (category_code) REFERENCES public.dict_category(code) ON DELETE SET NULL;


--
-- Name: product fk_product_platform; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_platform FOREIGN KEY (platform_code) REFERENCES public.dict_platform(code) ON DELETE SET NULL;


--
-- Name: store fk_store_country; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT fk_store_country FOREIGN KEY (country_code) REFERENCES public.dict_country(code) ON DELETE SET NULL;


--
-- Name: store fk_store_platform; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT fk_store_platform FOREIGN KEY (platform_code) REFERENCES public.dict_platform(code) ON DELETE SET NULL;


--
-- Name: store fk_store_target_category; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT fk_store_target_category FOREIGN KEY (target_category_code) REFERENCES public.dict_category(code);


--
-- Name: store fk_store_target_country; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT fk_store_target_country FOREIGN KEY (target_country_code) REFERENCES public.dict_country(code);


--
-- Name: login_logs login_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.login_logs
    ADD CONSTRAINT login_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: product product_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id);


--
-- Name: users users_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict ZewGAMgqew6uDlpphPVgumlMvUKpeqYgWAVZRbwH1Zdsc7tSUIzfhivULayvM4z

