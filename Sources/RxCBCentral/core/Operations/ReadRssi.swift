//
//  Copyright (c) 2019 Uber Technologies, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import RxSwift

public struct ReadRssi: GattOperation {
    
    public typealias Element = Int
    public typealias TraitType = SingleTrait
    public var result: Single<Int>
    
    public init() {
        self.init(timeoutSeconds: GattConstants.defaultOperationTimeout)
    }
    
    public init(timeoutSeconds: RxTimeInterval, scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)) {
        result =
            _peripheralSubject
                .take(1)
                .flatMapLatest { rxPeripheral in
                    rxPeripheral.readRSSI()
                }
                .share()
                .asSingle()
                .timeout(timeoutSeconds, scheduler: scheduler)
    }
    
    public func execute(with peripheral: RxPeripheral) {
        _peripheralSubject.onNext(peripheral)
    }
    
    private let _peripheralSubject = ReplaySubject<RxPeripheral>.create(bufferSize: 1)
}
