import Foundation
import FoundationModels
import Darwin

public func session(system: String = "") -> LanguageModelSession {
	return LanguageModelSession(instructions: system);
}

public func inference(session: LanguageModelSession, prompt: String) async -> String {
	do {
		return try await session.respond(to: prompt).content
	} catch let error {
        fputs("err: " + error.localizedDescription + "\n", stderr)
		return ""
	}
}

@_cdecl("session")
public func c_session(systemPtr: UnsafePointer<CChar>) -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(session(system: String(cString: systemPtr))).toOpaque()
}

@_cdecl("close_session")
public func c_close_session(sessionPtr: UnsafeMutableRawPointer) {
    Unmanaged<LanguageModelSession>.fromOpaque(sessionPtr).release()
}

@_cdecl("inference")
public func c_inference(sessionPtr: UnsafeMutableRawPointer, promptPtr: UnsafePointer<CChar>) -> UnsafeMutablePointer<CChar>? {
    let session = Unmanaged<LanguageModelSession>.fromOpaque(sessionPtr).takeUnretainedValue()
    let prompt = String(cString: promptPtr)
    
    let semaphore = DispatchSemaphore(value: 0)
    var resultString = ""
    
    Task {
        resultString = await inference(session: session, prompt: prompt)
        semaphore.signal()
    }
    
    semaphore.wait()
    return strdup(resultString)
}
