class AddJaccardFunctions < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
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

      CREATE OR REPLACE FUNCTION contents_score(a bigint[], b bigint)
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
    SQL
  end

  def down
    execute <<-SQL
      drop function if exists contents_score;
      drop function if exists jaccard_index;
    SQL
  end
end
