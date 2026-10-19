const articles = [
  {
    id: 'create-bill', category: 'Billing', title: 'Create a bill and take payment',
    questions: ['How do I generate a bill?', 'How do I create a bill?', 'How do I make a sale?', 'How do I charge a customer?'],
    keywords: ['bill', 'billing', 'sale', 'checkout', 'charge', 'payment', 'transaction', 'cashier'], page: 'billing',
    steps: ['Open New bill from the left menu.', 'Search the catalog and select each product. Adjust quantities in the order summary.', 'Choose Cash, UPI, or Card. Add a discount if needed.', 'Select Charge to record payment and complete the sale. Stock is reduced automatically.'],
  },
  {
    id: 'print-current-bill', category: 'Receipts', title: 'Print a bill after checkout',
    questions: ['How can I print a bill?', 'How do I print the receipt?', 'Can I print the bill now?'],
    keywords: ['print', 'receipt', 'printer', 'paper', 'checkout'], page: 'billing',
    steps: ['After a successful checkout, use Print bill in the confirmation banner.', 'Choose a connected printer in the browser print dialog, or choose Save as PDF.'],
  },
  {
    id: 'reprint-bill', category: 'Receipts', title: 'Reprint an earlier bill',
    questions: ['How do I reprint a bill?', 'How can I print an old receipt?', 'Can I print a bill later?', 'How do I print a previous transaction?'],
    keywords: ['reprint', 'old bill', 'previous bill', 'earlier bill', 'again', 'receipt copy'], page: 'sales',
    steps: ['Open Transactions from the left menu.', 'Find the bill in the list. You can search by bill number or staff member.', 'Click Print on that row, then select a printer or Save as PDF in the browser dialog.'],
  },
  {
    id: 'discount', category: 'Billing', title: 'Apply a bill discount',
    questions: ['How do I apply a discount?', 'Can I give a customer a discount?'],
    keywords: ['discount', 'offer', 'reduce price', 'bill total'], page: 'billing',
    steps: ['On New bill, add the products to the order first.', 'Enter the discount amount in the Discount field. It cannot be greater than the subtotal.', 'Review Total due before selecting Charge.'],
  },
  {
    id: 'payment-methods', category: 'Billing', title: 'Payment methods and tax',
    questions: ['Which payment methods can I accept?', 'Does the POS charge a card or UPI?', 'Does the POS calculate tax?'],
    keywords: ['cash', 'upi', 'card', 'payment methods', 'processor', 'tax', 'gst'], page: 'billing',
    steps: ['The bill can record Cash, UPI, or Card as the payment method.', 'The POS records the selected method; it does not connect to a payment processor or charge a card/UPI account.', 'Tax is currently set to zero in this demo.'],
  },
  {
    id: 'add-product', category: 'Products & stock', title: 'Add or edit a product',
    questions: ['How do I create a new product?', 'How do I add a product?', 'How can I edit a product?'],
    keywords: ['product', 'catalog', 'inventory', 'sku', 'price', 'add item', 'edit item'], page: 'products', adminOnly: true,
    steps: ['Open Products and choose Add product.', 'Enter the product name, unique SKU, price, stock quantity, and optional description.', 'Choose Add product to save. To edit an item, use its pencil icon in the product list.'],
  },
  {
    id: 'check-stock', category: 'Products & stock', title: 'Check stock levels',
    questions: ['How can I check stock levels?', 'How do I check the current inventory?', 'How many units are available?', 'How do I find low stock products?'],
    keywords: ['stock', 'quantity', 'inventory', 'units', 'low stock', 'restock'], page: 'products',
    steps: ['Open Products to see the available quantity and stock status for each item.', 'Items with five or fewer units are marked Low stock.', 'The dashboard and Reports page also highlight items that may need restocking.'],
  },
  {
    id: 'add-staff', category: 'Team access', title: 'Add a staff member',
    questions: ['How do I add a staff member?', 'How do I invite a teammate?', 'How can I create a cashier account?', 'How do I create a staff account?'],
    keywords: ['staff', 'team', 'teammate', 'invite', 'cashier', 'employee', 'account'], page: 'staff', adminOnly: true,
    steps: ['Open Team and choose Add teammate.', 'Enter their name, email address, and a temporary password of at least eight characters.', 'Choose Add teammate. Share the login details securely with the new staff member.'],
  },
  {
    id: 'staff-details', category: 'Team access', title: 'View staff details',
    questions: ['How can I see staff details?', 'How can I see the staff list?', 'Where can I view team members?', 'How do I view staff members?', 'How do I see staff members?'],
    keywords: ['staff', 'team', 'teammate', 'employee', 'details', 'list', 'view staff', 'team member', 'email'], page: 'staff',
    staffIntro: 'Staff accounts can view their own profile, but only admins can view the full team directory.',
    steps: ['Open Team from the left menu.', 'The team table shows each associate’s name, email address, role, and join date.'],
    staffSteps: ['Open Team from the left menu to see your own account profile.', 'Staff accounts cannot view other team members’ details. Ask an administrator if you need help with another account.'],
  },
  {
    id: 'returns', category: 'Returns', title: 'Process a return',
    questions: ['How do I process a return?', 'How can I refund an item?'],
    keywords: ['return', 'refund', 'damaged', 'restock'], page: 'returns', adminOnly: true,
    staffNote: 'Returns are accepted within 30 days of purchase. Recording a return is an admin-only action, so ask your store administrator to process it.',
    steps: ['Open Returns and choose Process a return.', 'Select the original bill and the product being returned.', 'Enter a quantity and reason, then record the return.', 'The refund uses the original sale price and returned units are added back to stock. Returns are accepted within 30 days, and the quantity cannot exceed the amount sold minus earlier returns.'],
  },
  {
    id: 'reports', category: 'Reports', title: 'View sales reports',
    questions: ['How do I view sales reports?', 'How can I check today’s sales?', 'Where can I see revenue and payment methods?'],
    keywords: ['report', 'revenue', 'sales totals', 'payment mix', 'daily sales', 'discounts'], page: 'reports', adminOnly: true,
    steps: ['Open Reports from the left menu.', 'Choose a date range to review net sales, transactions, average bill value, discounts, refunds, and payment mix.', 'Review the sales chart and low-stock section for more detail. The dashboard also shows a daily overview.'],
  },
  {
    id: 'transactions', category: 'Transactions', title: 'Find a transaction',
    questions: ['Where can I see my transactions?', 'How do I find a bill?', 'Can I see my previous bills?', 'Can staff see old bills?'],
    keywords: ['transaction', 'bill history', 'sales history', 'search bill', 'bill number', 'old bill', 'previous bill'], page: 'sales',
    steps: ['Open Transactions from the left menu.', 'Search using a bill number or staff member and filter by payment method.', 'Admins can view all sales. Staff accounts can view only their own sales.'],
  },
  {
    id: 'notifications', category: 'Notifications', title: 'Understand notifications',
    questions: ['What does a notification mean?', 'Why is there a dot on the bell?', 'What are low stock alerts?'],
    keywords: ['notification', 'bell', 'alert', 'unread', 'dot'], page: 'products',
    steps: ['Open the bell in the top bar to see current alerts.', 'Alerts include products with five or fewer units and bills completed in the last 24 hours.', 'Select an alert to open the related page. Use Mark all read to clear the unread count.'],
  },
  {
    id: 'suppliers', category: 'Suppliers', title: 'Manage suppliers',
    questions: ['How do I add a supplier?', 'Where do I manage suppliers?'],
    keywords: ['supplier', 'vendor', 'sourcing'], page: 'suppliers', adminOnly: true,
    steps: ['Open Suppliers from the left menu.', 'Choose Add supplier and enter the supplier details.', 'Save the form. You can edit or remove a supplier from the supplier workspace.'],
  },
]

const stopWords = new Set(['how', 'do', 'i', 'the', 'a', 'an', 'is', 'can', 'to', 'for', 'my', 'in', 'on', 'what', 'where', 'are', 'does', 'of', 'and', 'it', 'me', 'please', 'you', 'your', 'this', 'that', 'there', 'with', 'current', 'please'])
const normalize = (value) => value.toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim()
const singularize = (word) => word.endsWith('ies') && word.length > 4 ? `${word.slice(0, -3)}y` : word.endsWith('s') && !word.endsWith('ss') && word.length > 4 ? word.slice(0, -1) : word
const canonicalize = (word) => ({ view: 'see', show: 'see', browse: 'see', find: 'search' })[word] || word
const terms = (value) => normalize(value).split(/\s+/).map(singularize).map(canonicalize).filter((word) => word.length > 2 && !stopWords.has(word))

export const helpSuggestions = {
  admin: [
    'How do I create a bill?', 'How do I reprint a bill?',
    'How do I add a product?', 'How do I add a staff member?',
    'How do I process a return?', 'How do I view sales reports?',
  ],
  staff: [
    'How do I create a bill?', 'How do I reprint a bill?',
    'How can I check stock levels?', 'How do I apply a discount?',
    'Which payment methods can I accept?', 'What does a notification mean?',
  ],
}

export function findHelpArticle(question) {
  const queryTerms = [...new Set(terms(question))]
  if (!queryTerms.length) return null

  const exactMatches = []
  const ranked = []
  for (const article of articles) {
    const phrases = [...article.questions, article.title, ...article.keywords.filter((keyword) => terms(keyword).length >= 2)]
    const tokenSets = phrases.map((phrase) => [...new Set(terms(phrase))]).filter((phraseTerms) => phraseTerms.length)

    if (tokenSets.some((phraseTerms) => phraseTerms.length === queryTerms.length && phraseTerms.every((word) => queryTerms.includes(word)))) {
      exactMatches.push(article)
      continue
    }

    if (queryTerms.length < 2) continue
    let bestScore = 0
    for (const phraseTerms of tokenSets) {
      const matched = queryTerms.filter((word) => phraseTerms.includes(word)).length
      if (matched < 2) continue
      const precision = matched / queryTerms.length
      const recall = matched / phraseTerms.length
      const score = (2 * precision * recall) / (precision + recall)
      bestScore = Math.max(bestScore, score)
    }
    if (bestScore > 0) ranked.push({ article, score: bestScore })
  }

  if (exactMatches.length === 1) return exactMatches[0]
  if (exactMatches.length > 1) return null
  ranked.sort((a, b) => b.score - a.score)
  const [best, next] = ranked
  if (!best || best.score < 0.74 || (next && best.score - next.score < 0.12)) return null
  return best.article
}

export function getHelpAnswer(article, role) {
  if (article.adminOnly && role !== 'admin') {
    return {
      intro: article.staffNote || 'This action requires an admin account. Ask your store administrator to do it or grant the appropriate access.',
      steps: [],
      page: null,
      actionLabel: null,
    }
  }
  const staffView = role !== 'admin'
  return {
    intro: (staffView && article.staffIntro) || article.intro || 'Here are the steps for this POS workflow:',
    steps: (staffView && article.staffSteps) || article.steps,
    page: article.page,
    actionLabel: `Open ${article.page === 'sales' ? 'Transactions' : article.page === 'staff' ? 'Team' : article.page.charAt(0).toUpperCase() + article.page.slice(1)}`,
  }
}
