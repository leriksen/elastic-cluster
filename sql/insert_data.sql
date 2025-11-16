INSERT INTO students (name, teacher, year)
SELECT
    'Student ' || gs       AS name,
    'Teacher ' || (gs % 10 + 1) AS teacher,
    2000 + (gs % 5)        AS year
FROM generate_series(1, 10000) AS gs;