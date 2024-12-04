import EventKit

protocol CalendarManaging {
    func create(eventModel: CalendarEventModel, completion: @escaping (Bool) -> Void)
}

struct CalendarEventModel {
    var title: String
    var startDate: Date
    var endDate: Date
    var note: String?
}

final class CalendarManager: CalendarManaging {
    private let eventStore: EKEventStore = EKEventStore()
    
    func create(eventModel: CalendarEventModel, completion: @escaping (Bool) -> Void) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard let self = self else {
                completion(false)
                return
            }
            
            if granted {
                let event = EKEvent(eventStore: self.eventStore)
                event.title = eventModel.title
                event.startDate = eventModel.startDate
                event.endDate = eventModel.endDate
                event.notes = eventModel.note
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                    completion(true)
                } catch let error as NSError {
                    print("Failed to save event with error: \(error)")
                    completion(false)
                }
            } else {
                print("Access to calendar was not granted or an error occurred: \(String(describing: error))")
                completion(false)
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
}
