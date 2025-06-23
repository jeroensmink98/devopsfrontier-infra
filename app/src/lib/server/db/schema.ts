import { sqliteTable, integer, text } from 'drizzle-orm/sqlite-core';

export const user = sqliteTable('user', {
	id: integer('id').primaryKey(),
	age: integer('age')
});

export const book = sqliteTable('book', {
	id: integer('id').primaryKey(),
	title: text('title'),
	author: text('author'),
	published_date: text('published_date')
});

export const user_read_book = sqliteTable('user_read_book', {
	id: integer('id').primaryKey(),
	user_id: integer('user_id').references(() => user.id),
	book_id: integer('book_id').references(() => book.id)
});
