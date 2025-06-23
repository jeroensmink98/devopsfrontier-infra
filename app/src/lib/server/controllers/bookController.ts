import { db } from '../db';
import { book } from '../db/schema';
import { eq } from 'drizzle-orm';

export interface CreateBookData {
	title: string;
	author: string;
	published_date?: string;
}

export interface UpdateBookData {
	title: string;
	author: string;
	published_date?: string;
}

export class BookController {
	async getAllBooks() {
		try {
			const books = await db.select().from(book);
			return { success: true, data: books };
		} catch (error) {
			console.error('Database error fetching books:', error);
			return { success: false, error: 'Failed to fetch books' };
		}
	}

	async createBook(bookData: CreateBookData) {
		try {
			const newBook = await db
				.insert(book)
				.values({
					title: bookData.title,
					author: bookData.author,
					published_date: bookData.published_date
				})
				.returning();

			return { success: true, data: newBook[0] };
		} catch (error) {
			console.error('Database error creating book:', error);
			return { success: false, error: 'Failed to create book' };
		}
	}

	async updateBook(id: number, bookData: UpdateBookData) {
		try {
			const updatedBook = await db
				.update(book)
				.set({
					title: bookData.title,
					author: bookData.author,
					published_date: bookData.published_date
				})
				.where(eq(book.id, id))
				.returning();

			if (updatedBook.length === 0) {
				return { success: false, error: 'Book not found' };
			}

			return { success: true, data: updatedBook[0] };
		} catch (error) {
			console.error('Database error updating book:', error);
			return { success: false, error: 'Failed to update book' };
		}
	}

	async deleteBook(id: number) {
		try {
			const deletedBook = await db.delete(book).where(eq(book.id, id)).returning();

			if (deletedBook.length === 0) {
				return { success: false, error: 'Book not found' };
			}

			return { success: true, data: deletedBook[0] };
		} catch (error) {
			console.error('Database error deleting book:', error);
			return { success: false, error: 'Failed to delete book' };
		}
	}

	async getBookById(id: number) {
		try {
			const books = await db.select().from(book).where(eq(book.id, id));

			if (books.length === 0) {
				return { success: false, error: 'Book not found' };
			}

			return { success: true, data: books[0] };
		} catch (error) {
			console.error('Database error fetching book:', error);
			return { success: false, error: 'Failed to fetch book' };
		}
	}
}

// Export a singleton instance
export const bookController = new BookController();
