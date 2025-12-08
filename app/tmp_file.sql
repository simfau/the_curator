CREATE OR REPLACE FUNCTION jaccard_index(a bigint[], b bigint[])
RETURNS double precision
LANGUAGE sql
IMMUTABLE
STRICT
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

CREATE OR REPLACE FUNCTION contents_jaccard(a bigint[], b bigint)
RETURNS double precision
LANGUAGE sql
IMMUTABLE
STRICT
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

SELECT id, content_a + content_b AS combined
FROM (
  SELECT results.id,
    contents_jaccard(results.tag_ids, 3030) AS content_a,
    contents_jaccard(results.tag_ids, 3343) As content_b
  FROM (
    select contents.id, array_agg(content_tags.tag_id) AS tag_ids
    FROM contents
    JOIN content_tags ON contents.id = content_tags.content_id
    group by contents.id
  ) as results
) as list_of_results ORDER BY combined DESC


-- ARRAY(SELECT content_tags.tag_id FROM contents JOIN content_tags ON content_tags.content_id = contents.id where contents.id = 3030)
