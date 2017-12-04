require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 2, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }

  # get all todo items
  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }
    context 'when todo exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all todo items' do
        expect(json.size).to eq(2)
      end
    end

    context 'when todo does not exist' do
      let(:todo_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # get a todo item
  describe 'GET /todos/:todo_id/items/:id' do
    before { get "/todos/#{todo_id}/items/#{id}" }
    context 'when item exists' do
      it 'returns a todo item' do
        expect(json['id']).to eq(id)
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    context 'when item does not exist' do
      let(:id) { 0 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'POST /todos/:todo_id/items' do
    context 'when params is valid' do
      let(:valid_attributes) { { name: 'Item A', done: false, todo_id: todo_id } }
      before { post "/todos/#{todo_id}/items", valid_attributes }
      it 'returns the item' do
        expect(json).not_to be_empty
        expect(json['name']).to eq('Item A')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when params is NOT valid' do
      before { post "/todos/#{todo_id}/items", { todo_id: todo_id } }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation error message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /todos/:todo_id/items/:item_id' do
    context 'when params is valid' do
      before { put "/todos/#{todo_id}/items/#{id}", { name: 'Item B' } }
      it 'updates the item record' do
        expect(response.body).to be_empty

        updated_item = Item.find(id)
        expect(updated_item.name).to match(/Item B/)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
    xcontext 'when params is NOT valid' do
      before { put "/todos/#{todo_id}/items/#{id}", { name: '' } }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a validation error message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'DELETE /todos/:todo_id/items/:item_id' do
    before { delete "/todos/#{todo_id}/items/#{id}" }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'deleted the item' do
      expect(Item.find_by(id: id)).to be(nil)
    end
  end
end
