### ViewModel을 테스트하기 용이하게 만들기

먼저 ViewModel에 Action을 두어 외부로의 Action을 테스트 시 동일하게 발상할 수 있도록 두었습니다. 또한 input 메서드를 통해서 들어온 Action에 대한 동작을 처리하고 output을 State로 관리하여 ViewController로 나갈 output을 관리하였습니다.

```swift
protocol ViewModelable {
    associatedtype Action
    associatedtype State
    
    var output: AnyPublisher<State, Never> { get }
    func input(_ action: Action) 
}
```
<br><br>
### ViewController를 테스트하기 용이하게 만들기
ViewModel을 테스트 시 정상적인 output을 ViewController에 전달하는지 테스트 하기 위해 associatedtype을 통해서 ViewModelable을 타입으로 가지는 ViewModel을 가지도록 Presntable 이라는 Protocol로 두고 이를 채택한 ViewControllerMock을 구현하였습니다.

```swift
protocol Presentable {
    associatedtype ViewModelType: ViewModelable
    
    var viewModel: ViewModelType { get }
    var statePublisher: AnyPublisher<ViewModelType.State, Never> { get }
}
```
```swift
final class ViewControllerMock<T: ViewModelable>: Presentable {
    
    typealias ViewModelType = T
    
    var viewModel: ViewModelType
    
    var statePublisher: AnyPublisher<ViewModelType.State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private let stateSubject = PassthroughSubject<ViewModelType.State, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        viewModel.output
            .sink { [weak self] state in self?.stateSubject.send(state) }
            .store(in: &cancellables)
    }
}
```
<br><br>
### 테스트하기 용이하게 의존성 두기
SearchViewModel에는 APIservice Class에 의존성을 둡니다. 
```swift
/// SearchViewModel
    struct Dependency {
        let apiService: APIServiceProtocol
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
```
그러나 APIService Class에 직접 두는게 아니라 APIService Protocol에 두어 테스트 시 APIServiceStub을 주입시켜 원하는 네트워킹 결과를 받을 수 있도록 구현하였습니다.
```swift
protocol APIServiceProtocol {
    func apiRequest<T: Decodable, Router: RouterProtocol>(type: T.Type, router: Router) async throws -> T
}
```
```swift
final class APIServiceStub: APIServiceProtocol {
    
    private let error: Error?
    private let data: Decodable?
    
    init(error: Error? = nil, data: Decodable? = nil) {
        self.error = error
        self.data = data
    }
    
    func apiRequest<T: Decodable, Router: RouterProtocol>(type: T.Type, router: Router) async throws -> T {
        
        if let error { throw error }
        
        guard let data = data as? T else {
            throw URLError(.badServerResponse)
        }
        
       return data
    }
}
```
예시 코드
```swift
let books = [
    Book(title: "Learning Swift 2 Programming, 2nd Edition",
         subtitle: "",
         isbn13: "9780134431598",
         price: "$28.32",
         image: "https://itbook.store/img/books/9780134431598.png",
         url: "https://itbook.store/books/9780134431598"),
    Book(title: "Learning Swift 3 Programming, 3nd Edition",
         subtitle: "",
         isbn13: "9780134431599",
         price: "$29.32",
         image: "https://itbook.store/img/books/9780134431599.png",
         url: "https://itbook.store/books/9780134431599")]

let searchResponseDTO = SearchResponseDTO(error: "0", total: "100", page: "1", books: books)
let dependency = SearchViewModel.Dependency(apiService: APIServiceStub(error: nil, data: searchResponseDTO))

searchViewModel = SearchViewModel(dependency: dependency)
```
<br><br>
### Troubleshooting
- [Issue #2](https://github.com/Yoon-hub/DaangnPay/issues/2)
- [Issue #3](https://github.com/Yoon-hub/DaangnPay/issues/3)

<br><br>

### 시연 영상
https://github.com/Yoon-hub/DaangnPay/assets/92036498/72636f8f-ca1f-4efd-bb2d-d80f87aa3060
