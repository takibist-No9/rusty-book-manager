-- 1. Create a function that automatically updates updated_at
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS trigger AS $$
  BEGIN
    new.updated_at := 'now';
    RETURN new;
  END;
$$ LANGUAGE plpgsql;

-- 2. Create the books table
CREATE TABLE IF NOT EXISTS books (
  book_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL,
  isbn VARCHAR(255) NOT NULL,
  description VARCHAR(1024) NOT NULL,
  created_at TIMESTAMP(3) WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at TIMESTAMP(3) WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
);

-- 3. Add a trigger for the books table
CREATE TRIGGER books_updated_at_trigger
    BEFORE UPDATE ON books FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();
