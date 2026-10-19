import { useEffect, useRef, useState } from 'react'
import { ArrowRight, BookOpen, CircleHelp, MessageCircle, RotateCcw, X } from 'lucide-react'
import { findHelpArticle, getHelpAnswer, helpSuggestions } from './helpArticles.js'

const welcome = {
  id: 'welcome', role: 'assistant',
  text: 'Hi! Choose a question below and I’ll show you the verified steps for that POS workflow.',
}

function createAnswer(question, role) {
  const article = findHelpArticle(question)
  if (!article) {
    return {
      id: `${Date.now()}-answer`, role: 'assistant', text: 'I couldn’t find a verified guide for that question. Try one of the suggested topics below, or ask your store administrator for help.',
    }
  }
  const answer = getHelpAnswer(article, role)
  return {
    id: `${Date.now()}-answer`, role: 'assistant', title: article.title,
    text: answer.intro,
    steps: answer.steps,
    page: answer.page,
    actionLabel: answer.actionLabel,
  }
}

export default function HelpCenter({ user, onClose, onNavigate, mobilePreview = false }) {
  const [messages, setMessages] = useState([welcome])
  const activeSuggestions = helpSuggestions[user.role] || helpSuggestions.staff
  const listRef = useRef(null)
  useEffect(() => {
    const closeOnEscape = (event) => { if (event.key === 'Escape') onClose() }
    document.addEventListener('keydown', closeOnEscape)
    return () => document.removeEventListener('keydown', closeOnEscape)
  }, [onClose])
  useEffect(() => { listRef.current?.scrollTo({ top: listRef.current.scrollHeight, behavior: 'smooth' }) }, [messages])

  const ask = (text) => {
    setMessages((current) => [...current, { id: `${Date.now()}-question`, role: 'user', text }, createAnswer(text, user.role)])
  }

  return <div className={`help-backdrop ${mobilePreview ? 'help-backdrop-preview' : ''}`} onMouseDown={(event) => { if (event.target === event.currentTarget) onClose() }}>
    <section className="help-panel" role="dialog" aria-modal="true" aria-labelledby="help-title">
      <header className="help-header"><div className="help-header-icon"><CircleHelp size={19} /></div><div className="help-header-copy"><strong id="help-title">Loom & Lane Help</strong><small><span /> Verified POS guides · {user.role === 'admin' ? 'Admin' : 'Staff'} view</small></div><button className="icon-button" aria-label="Close help centre" onClick={onClose}><X size={19} /></button></header>
      <div className="help-source-note"><BookOpen size={14} /> Answers use documented features and workflows. The assistant can’t change store records.</div>
      <div className="help-messages" ref={listRef} aria-live="polite">
        {messages.map((message) => <div className={`help-message ${message.role}`} key={message.id}>
          {message.role === 'assistant' && <span className="help-message-icon"><MessageCircle size={14} /></span>}
          <div className="help-bubble">
            {message.title && <strong className="help-answer-title">{message.title}</strong>}
            <p>{message.text}</p>
            {message.steps?.length > 0 && <ol>{message.steps.map((step, index) => <li key={`${message.id}-${index}`}>{step}</li>)}</ol>}
            {message.page && <button className="help-action" onClick={() => onNavigate(message.page)}>{message.actionLabel}<ArrowRight size={14} /></button>}
          </div>
        </div>)}
        <div className="help-suggestions"><span>Suggested questions</span>{activeSuggestions.map((suggestion) => <button key={suggestion} onClick={() => ask(suggestion)}>{suggestion}<ArrowRight size={13} /></button>)}</div>
      </div>
      <footer className="help-footer"><RotateCcw size={12} /> Choose any question again whenever you need its steps.</footer>
    </section>
  </div>
}
