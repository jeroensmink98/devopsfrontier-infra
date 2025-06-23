import { describe, expect, it } from 'vitest';
import { bookController } from './bookController';
import { faker } from '@faker-js/faker';

const bookData = {
	title: faker.lorem.sentence({ min: 1, max: 3 }),
	author: faker.person.fullName(),
	published_date: faker.date.past().toISOString()
};

describe('BookController', () => {
	it('should create a book', async () => {
		const book = await bookController.createBook({
			title: bookData.title,
			author: bookData.author,
			published_date: bookData.published_date
		});
		expect(book).toBeDefined();
		console.log(book);
	});

	it('should get all books', async () => {
		const books = await bookController.getAllBooks();
		expect(books).toBeDefined();
		console.log(books);
	});

	it('should get a book by id', async () => {
		const book = await bookController.getBookById(1);
		expect(book).toBeDefined();
		console.log(book);
	});
});
