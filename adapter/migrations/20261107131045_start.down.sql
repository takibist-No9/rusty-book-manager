DROP TRIGGER IF EXISTS books_updated_at_trigger ON books;
-- pgls-ignore lint/banDropTable: down migration intentionally drops the table
DROP TABLE IF EXISTS books;
DROP FUNCTION IF EXISTS set_updated_at;
