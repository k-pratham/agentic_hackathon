import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ChatMessage {
  role: 'user' | 'assistant';
  content: string;
}

export interface ChatResponse {
  status: string;
  message: string;
  chart_metadata?: any;
}

@Injectable({
  providedIn: 'root'
})
export class ChatService {
  constructor(private http: HttpClient) { }

  sendMessage(thread_id: string, message: string, department_id: number, action: string = 'chat'): Observable<ChatResponse> {
    return this.http.post<ChatResponse>('/api/v1/chat', {
      thread_id,
      message,
      department_id,
      action
    });
  }

  getHistory(thread_id: string): Observable<{status: string, messages: ChatMessage[]}> {
    return this.http.get<{status: string, messages: ChatMessage[]}>(`/api/v1/chat/history/${thread_id}`);
  }
}
