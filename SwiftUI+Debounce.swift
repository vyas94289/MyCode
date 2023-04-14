init() {
    $searchTerm
      .debounce(for: 0.8, scheduler: DispatchQueue.main) 1
      .map { searchTerm -> AnyPublisher<[Book], Never> in 2
        self.isSearching = true
        return self.searchBooks(matching: searchTerm)
      }
      .switchToLatest() 3
      .receive(on: DispatchQueue.main) 4
      .sink(receiveValue: { books in 5
        self.result = books
        self.isSearching = false
      })
      .store(in: &cancellables) 6 
  }
