import { Component, OnInit, signal, effect, ElementRef, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ChatService, ChatMessage } from '../../core/chat.service';
import { AuthService } from '../../core/auth.service';

@Component({
  selector: 'app-chat-area',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './chat-area.component.html',
  styleUrl: './chat-area.component.css'
})
export class ChatAreaComponent implements OnInit {
  @ViewChild('scrollContainer') private scrollContainer!: ElementRef;
  
  messages = signal<ChatMessage[]>([]);
  inputText: string = '';
  loading: boolean = false;
  threadId: string = 'thread_' + Math.random().toString(36).substring(7);

  constructor(public chatService: ChatService, public authService: AuthService) {
    effect(() => {
      this.messages();
      setTimeout(() => this.scrollToBottom(), 100);
    });
  }

  ngOnInit() {
    // Check if user is logged in
  }

  sendMessage() {
    if (!this.inputText.trim() || this.loading) return;
    
    const userMessage = this.inputText;
    this.messages.update(m => [...m, { role: 'user', content: userMessage }]);
    this.inputText = '';
    this.loading = true;

    const deptId = this.authService.user()?.dept_id || 1;

    this.chatService.sendMessage(this.threadId, userMessage, deptId).subscribe({
      next: (res) => {
        this.loading = false;
        
        if (res.status === 'requires_clarification') {
           this.messages.update(m => [...m, { role: 'assistant', content: res.message }]);
        } else {
           this.messages.update(m => [...m, { role: 'assistant', content: res.message }]);
           // Handle chart rendering if needed in the future
        }
      },
      error: (err) => {
        this.loading = false;
        this.messages.update(m => [...m, { role: 'assistant', content: 'Sorry, I encountered an error. Please try again.' }]);
      }
    });
  }

  private scrollToBottom(): void {
    try {
      this.scrollContainer.nativeElement.scrollTop = this.scrollContainer.nativeElement.scrollHeight;
    } catch(err) {}
  }
}
