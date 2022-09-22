CREATE TABLE versions (
     id SERIAL PRIMARY KEY,  
     ref TEXT NOT NULL,  
     version_number INT NOT NULL,
     version_user TEXT NOT NULL,
     content Bytea NOT NULL,
     created_at TIMESTAMP
)