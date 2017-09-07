1) 
SELECT COUNT( r.r_id) + (SELECT COUNT( n.n_id) AS SUM FROM news n) AS SUM 
FROM reviews r;
2)
SELECT nc.nc_name, COUNT(n.n_id)
FROM news_categories nc
LEFT JOIN news n
ON n.n_category = nc.nc_id
GROUP BY nc.nc_name;
3)
SELECT rc.rc_name, COUNT(r.r_id)
FROM reviews_categories rc
LEFT JOIN reviews r
ON r.r_category = rc.rc_id
GROUP BY rc.rc_name;
4)
SELECT nc.nc_name AS category_name, n.n_dt
FROM news n
INNER JOIN news_categories nc
ON nc.nc_id = n.n_category
GROUP BY category_name
UNION 
SELECT rc.rc_name AS category_name, r.r_dt
FROM reviews r
INNER JOIN reviews_categories rc
ON rc.rc_id = r.r_category
GROUP BY category_name;
5)
SELECT p.p_name, b.b_id, b.b_url
FROM pages p 
JOIN m2m_banners_pages m2m ON p.p_id = m2m.p_id
JOIN banners b ON m2m.b_id = b.b_id
WHERE p.p_parent IS NULL;
6)
SELECT DISTINCT p.p_name 
FROM pages p
JOIN m2m_banners_pages m2m ON m2m.p_id = p.p_id
WHERE m2m.b_id IS NOT NULL;
7)
SELECT DISTINCT p.p_name 
FROM pages p
LEFT JOIN m2m_banners_pages m2m ON m2m.p_id = p.p_id
WHERE  m2m.b_id IS  NULL;
8)
SELECT m2m.b_id , b.b_url
FROM m2m_banners_pages m2m
JOIN banners b  ON m2m.b_id = b.b_id
GROUP BY m2m.b_id;
9)
SELECT b.b_id , b.b_url
FROM banners b
WHERE NOT EXISTS 
	(SELECT * FROM m2m_banners_pages m2m WHERE m2m.b_id = b.b_id )
10)
SELECT b.b_id, b.b_url, (b.b_click/b.b_show * 100) AS rate
FROM banners b
WHERE (b.b_click/b.b_show) >=0.8
	AND b.b_show IS NOT NULL;
11) 
SELECT DISTINCT p.p_name
FROM pages p 
JOIN m2m_banners_pages m2m ON m2m.p_id = p.p_id
JOIN banners b ON b.b_id= m2m.b_id
WHERE b.b_text IS NOT NULL;
12) 
SELECT DISTINCT p.p_name
FROM pages p 
JOIN m2m_banners_pages m2m ON m2m.p_id = p.p_id
JOIN banners b ON b.b_id= m2m.b_id
WHERE b.b_pic IS NOT NULL;
13)
SELECT n.n_header AS header, n.n_dt AS date
FROM news n
WHERE n.n_dt BETWEEN '2011-01-01 00:00:01' AND '2011-12-31 23:59:59'
UNION
SELECT r.r_header AS header, r.r_dt AS date
FROM reviews r
WHERE r.r_dt BETWEEN '2011-01-01 00:00:01' AND '2011-12-31 23:59:59';
14)
SELECT nc.nc_name AS category 
FROM news_categories nc
LEFT JOIN news n 
ON n.n_category = nc.nc_id 
WHERE n.n_category IS NULL
UNION 
SELECT rc.rc_name AS category 
FROM reviews_categories rc
LEFT JOIN reviews r 
ON r.r_category = rc.rc_id 
WHERE r.r_category IS NULL
15)
SELECT n.n_header, n.n_dt
FROM news n 
JOIN news_categories nc
ON n.n_category = nc.nc_id
WHERE 
	nc.nc_name = 'Логистика'
    AND
    n.n_dt BETWEEN '2012-01-01 00:00:01' AND '2012-12-31 23:59:59';
16)
SELECT YEAR(n.n_dt) AS 'year', COUNT(*)
FROM news n
GROUP BY YEAR(n.n_dt);
17)
SELECT  b.b_url, b.b_id
FROM banners  b
JOIN banners s ON b.b_url = s.b_url
WHERE b.b_id<s.b_id
UNION
(SELECT  s.b_url,s.b_id
FROM banners  b
JOIN banners s ON b.b_url = s.b_url
WHERE b.b_id<s.b_id)
ORDER BY b_id;
18)
SELECT p2.p_name, b.b_id, b.b_url
FROM pages p1
JOIN pages p2  ON p1.p_id =p2. p_parent
JOIN m2m_banners_pages m2m ON p2.p_id = m2m.p_id
JOIN banners b ON m2m.b_id = b.b_id
WHERE p1.p_name = 'Юридическим лицам';
19)
SELECT b.b_id, b.b_url, (b.b_click/b.b_show)
FROM banners b
WHERE b.b_pic IS NOT NULL
ORDER BY  (b.b_click/b.b_show) DESC;
20)
SELECT header, date
FROM (
		SELECT n_header AS header, n_dt AS date
		FROM news
        UNION
        SELECT r_header, r_dt
        FROM reviews) AS data
WHERE date = (SELECT LEAST(MIN(n_dt), MIN(r_dt)) FROM news, reviews);
21)
SELECT b.b_url, b.b_id
FROM banners b
WHERE b_url IN (SELECT b_url FROM banners GROUP BY b_url HAVING COUNT(*) = 1);
22)
SELECT p.p_name , COUNT(*) AS banners_count
FROM pages p 
JOIN m2m_banners_pages m2m ON p.p_id = m2m.p_id
JOIN banners b ON m2m.b_id = b.b_id
GROUP BY p.p_name
ORDER BY banners_count DESC, p.p_name;
23)
SELECT n_header AS header, n_dt AS date
FROM news n
WHERE n.n_dt = (SELECT MAX(n.n_dt) FROM news n)
UNION
SELECT r_header AS header, r_dt AS date
FROM reviews r
WHERE r.r_dt = (SELECT MAX(r.r_dt) FROM reviews r);
24)
SELECT b.b_id, b.b_url, b.b_text
FROM banners b
WHERE b.b_text = SUBSTRING(b.b_url, 8,LENGTH(b.b_url));
25)
SELECT p.p_name 
FROM pages p 
JOIN m2m_banners_pages m2m ON p.p_id = m2m.p_id
JOIN banners b ON m2m.b_id = b.b_id
ORDER BY b.b_click/b.b_show  DESC
LIMIT 1;
26) 
SELECT AVG(b.b_click/b.b_show)
FROM banners b;
27)
SELECT AVG(b.b_click/b.b_show)
FROM banners b
WHERE b.b_pic IS NULL;
28)
SELECT COUNT(b.b_id) AS COUNT
FROM pages p
JOIN m2m_banners_pages m2m ON p.p_id = m2m.p_id
JOIN banners b ON m2m.b_id = b.b_id
WHERE p.p_parent IS NULL;
29)
SELECT  b.b_id, b.b_url, count( m2m.b_id) AS `COUNT`
FROM m2m_banners_pages m2m
JOIN   banners b ON b.b_id = m2m.b_id
GROUP BY m2m.b_id
LIMIT 1;
30)
SELECT p.p_name, COUNT(m2m.p_id) AS COUNT
FROM m2m_banners_pages m2m
JOIN pages p ON p.p_id = m2m.p_id
GROUP BY m2m.p_id
HAVING COUNT( m2m.p_id) =
	(SELECT MAX(d) FROM 
		(SELECT COUNT(m2m.b_id) d
		FROM m2m_banners_pages m2m
		GROUP BY m2m.p_id) dd);