import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router';
import { ArrowLeft, Search, Filter, Trash2, Edit3, Paperclip, Repeat, AlertCircle } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { motion, AnimatePresence } from 'motion/react';

const fmt = (n: number) => `₹${n.toLocaleString('en-IN')}`;

export function TransactionHistory() {
  const navigate = useNavigate();
  const { transactions, deleteTransaction, settings, getCategoryById } = useApp();
  const [search, setSearch] = useState('');
  const [activeTab, setActiveTab] = useState<'all' | 'income' | 'expense'>('all');
  const [sortBy, setSortBy] = useState<'date' | 'amount'>('date');
  const [showFilter, setShowFilter] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState<string | null>(null);

  const isDark = settings.darkMode;
  const cardBg = isDark ? 'rgba(30,41,59,0.9)' : '#FFFFFF';
  const mainText = isDark ? '#F8FAFC' : '#0F172A';
  const subText = isDark ? '#64748B' : '#9CA3AF';
  const borderColor = isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)';
  const inputBg = isDark ? 'rgba(15,23,42,0.8)' : '#F1F5F9';

  const filtered = useMemo(() => {
    let list = [...transactions];
    if (activeTab !== 'all') list = list.filter(t => t.type === activeTab);
    if (search) {
      const q = search.toLowerCase();
      list = list.filter(t => t.title.toLowerCase().includes(q) || t.notes?.toLowerCase().includes(q) || t.category.toLowerCase().includes(q));
    }
    if (sortBy === 'amount') list.sort((a, b) => b.amount - a.amount);
    else list.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
    return list;
  }, [transactions, activeTab, search, sortBy]);

  // Group by date
  const grouped = useMemo(() => {
    const groups: Record<string, typeof filtered> = {};
    filtered.forEach(tx => {
      if (!groups[tx.date]) groups[tx.date] = [];
      groups[tx.date].push(tx);
    });
    return Object.entries(groups).sort(([a], [b]) => new Date(b).getTime() - new Date(a).getTime());
  }, [filtered]);

  const totalIncome = filtered.filter(t => t.type === 'income').reduce((s, t) => s + t.amount, 0);
  const totalExpense = filtered.filter(t => t.type === 'expense').reduce((s, t) => s + t.amount, 0);

  const formatDateLabel = (dateStr: string) => {
    const d = new Date(dateStr);
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    if (d.toDateString() === today.toDateString()) return 'Today';
    if (d.toDateString() === yesterday.toDateString()) return 'Yesterday';
    return d.toLocaleDateString('en-IN', { weekday: 'short', day: 'numeric', month: 'short' });
  };

  return (
    <div style={{ background: isDark ? '#0F172A' : '#F8FAFC', minHeight: '100%', fontFamily: "'Poppins', sans-serif" }}>
      {/* Header */}
      <div className="flex items-center gap-3 px-5 pt-12 pb-4">
        <button onClick={() => navigate(-1)} className="flex items-center justify-center rounded-xl" style={{ width: '40px', height: '40px', background: cardBg, border: `1px solid ${borderColor}` }}>
          <ArrowLeft size={20} color={mainText} />
        </button>
        <h1 style={{ color: mainText, fontSize: '18px', fontWeight: 700, flex: 1 }}>Transactions</h1>
        <button onClick={() => setShowFilter(!showFilter)} className="flex items-center justify-center rounded-xl" style={{ width: '40px', height: '40px', background: showFilter ? 'rgba(41,121,255,0.15)' : cardBg, border: `1px solid ${showFilter ? '#2979FF' : borderColor}` }}>
          <Filter size={18} color={showFilter ? '#2979FF' : subText} />
        </button>
      </div>

      {/* Summary strip */}
      <div className="mx-5 mb-4 p-3 rounded-2xl flex items-center gap-4" style={{ background: cardBg, border: `1px solid ${borderColor}` }}>
        <div className="flex-1 text-center">
          <p style={{ color: '#00C853', fontSize: '14px', fontWeight: 700 }}>{fmt(totalIncome)}</p>
          <p style={{ color: subText, fontSize: '10px' }}>Income</p>
        </div>
        <div style={{ width: '1px', height: '30px', background: borderColor }} />
        <div className="flex-1 text-center">
          <p style={{ color: '#FF5252', fontSize: '14px', fontWeight: 700 }}>{fmt(totalExpense)}</p>
          <p style={{ color: subText, fontSize: '10px' }}>Expenses</p>
        </div>
        <div style={{ width: '1px', height: '30px', background: borderColor }} />
        <div className="flex-1 text-center">
          <p style={{ color: '#2979FF', fontSize: '14px', fontWeight: 700 }}>{filtered.length}</p>
          <p style={{ color: subText, fontSize: '10px' }}>Transactions</p>
        </div>
      </div>

      {/* Search */}
      <div className="px-5 mb-4">
        <div className="relative">
          <Search size={16} color={subText} style={{ position: 'absolute', left: '14px', top: '50%', transform: 'translateY(-50%)' }} />
          <input
            placeholder="Search transactions..."
            value={search}
            onChange={e => setSearch(e.target.value)}
            style={{
              background: inputBg,
              border: `1px solid ${borderColor}`,
              borderRadius: '14px',
              color: mainText,
              padding: '12px 16px 12px 40px',
              fontSize: '13px',
              width: '100%',
              outline: 'none',
              fontFamily: "'Poppins', sans-serif",
            }}
          />
        </div>
      </div>

      {/* Filter panel */}
      <AnimatePresence>
        {showFilter && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
            className="px-5 mb-4 overflow-hidden"
          >
            <div className="p-4 rounded-2xl flex items-center justify-between" style={{ background: cardBg, border: `1px solid ${borderColor}` }}>
              <div>
                <p style={{ color: subText, fontSize: '11px', marginBottom: '6px' }}>Sort by</p>
                <div className="flex gap-2">
                  {(['date', 'amount'] as const).map(s => (
                    <button
                      key={s}
                      onClick={() => setSortBy(s)}
                      className="px-3 py-1.5 rounded-lg capitalize"
                      style={{
                        background: sortBy === s ? 'rgba(41,121,255,0.15)' : inputBg,
                        border: `1px solid ${sortBy === s ? '#2979FF' : borderColor}`,
                        color: sortBy === s ? '#2979FF' : subText,
                        fontSize: '12px',
                        fontWeight: sortBy === s ? 600 : 400,
                      }}
                    >
                      {s}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Tabs */}
      <div className="px-5 mb-4">
        <div className="flex rounded-xl p-1 gap-1" style={{ background: cardBg, border: `1px solid ${borderColor}` }}>
          {(['all', 'income', 'expense'] as const).map(tab => {
            const colors = { all: '#2979FF', income: '#00C853', expense: '#FF5252' };
            return (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className="flex-1 py-2 rounded-lg capitalize transition-all"
                style={{
                  background: activeTab === tab ? `${colors[tab]}18` : 'transparent',
                  border: activeTab === tab ? `1px solid ${colors[tab]}40` : '1px solid transparent',
                  color: activeTab === tab ? colors[tab] : subText,
                  fontSize: '12px',
                  fontWeight: activeTab === tab ? 600 : 400,
                }}
              >
                {tab}
              </button>
            );
          })}
        </div>
      </div>

      {/* Transaction groups */}
      <div className="px-5">
        {grouped.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 gap-4">
            <div className="text-6xl">📭</div>
            <p style={{ color: mainText, fontSize: '16px', fontWeight: 600 }}>No transactions found</p>
            <p style={{ color: subText, fontSize: '13px', textAlign: 'center' }}>
              {search ? 'Try a different search term' : 'Add your first transaction'}
            </p>
          </div>
        ) : (
          grouped.map(([date, txns]) => (
            <div key={date} className="mb-4">
              <div className="flex items-center justify-between mb-2">
                <span style={{ color: subText, fontSize: '12px', fontWeight: 600 }}>{formatDateLabel(date)}</span>
                <span style={{ color: subText, fontSize: '11px' }}>
                  {txns.reduce((s, t) => t.type === 'income' ? s + t.amount : s - t.amount, 0) >= 0
                    ? `+${fmt(Math.abs(txns.reduce((s, t) => t.type === 'income' ? s + t.amount : s - t.amount, 0)))}`
                    : `-${fmt(Math.abs(txns.reduce((s, t) => t.type === 'income' ? s + t.amount : s - t.amount, 0)))}`
                  }
                </span>
              </div>
              <div className="flex flex-col gap-2">
                {txns.map(tx => {
                  const cat = getCategoryById(tx.category);
                  return (
                    <motion.div
                      key={tx.id}
                      layout
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, x: -100 }}
                      className="flex items-center gap-3 p-3 rounded-2xl"
                      style={{ background: cardBg, border: `1px solid ${borderColor}` }}
                    >
                      <div
                        className="flex items-center justify-center rounded-xl text-xl"
                        style={{ width: '42px', height: '42px', flexShrink: 0, background: `${cat?.color || '#888'}18` }}
                      >
                        {cat?.icon || '💰'}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1">
                          <span style={{ color: mainText, fontSize: '13px', fontWeight: 600 }} className="truncate">{tx.title}</span>
                          {tx.isRecurring && <Repeat size={10} color="#A29BFE" />}
                          {tx.hasAttachment && <Paperclip size={10} color="#94A3B8" />}
                        </div>
                        <div className="flex items-center gap-2">
                          <span style={{ color: subText, fontSize: '10px' }}>{cat?.name} • {tx.paymentMethod}</span>
                          {tx.syncStatus !== 'synced' && (
                            <span className="rounded-full px-1.5 py-0.5" style={{
                              background: tx.syncStatus === 'pending' ? 'rgba(255,213,79,0.15)' : 'rgba(255,82,82,0.15)',
                              color: tx.syncStatus === 'pending' ? '#FFD54F' : '#FF5252',
                              fontSize: '9px'
                            }}>
                              {tx.syncStatus.toUpperCase()}
                            </span>
                          )}
                        </div>
                      </div>
                      <div className="flex flex-col items-end gap-1">
                        <span style={{ color: tx.type === 'income' ? '#00C853' : '#FF5252', fontSize: '13px', fontWeight: 700 }}>
                          {tx.type === 'income' ? '+' : '-'}{fmt(tx.amount)}
                        </span>
                        <div className="flex gap-1">
                          <button
                            onClick={() => navigate(`/app/add-transaction?edit=${tx.id}`)}
                            className="p-1 rounded-lg"
                            style={{ background: 'rgba(41,121,255,0.1)' }}
                          >
                            <Edit3 size={12} color="#2979FF" />
                          </button>
                          <button
                            onClick={() => setDeleteConfirm(tx.id)}
                            className="p-1 rounded-lg"
                            style={{ background: 'rgba(255,82,82,0.1)' }}
                          >
                            <Trash2 size={12} color="#FF5252" />
                          </button>
                        </div>
                      </div>
                    </motion.div>
                  );
                })}
              </div>
            </div>
          ))
        )}
      </div>

      {/* Delete confirm */}
      <AnimatePresence>
        {deleteConfirm && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 flex items-end justify-center z-50"
            style={{ background: 'rgba(0,0,0,0.7)' }}
          >
            <motion.div
              initial={{ y: 100 }}
              animate={{ y: 0 }}
              exit={{ y: 100 }}
              className="w-full p-6 rounded-t-3xl"
              style={{ background: isDark ? '#1E293B' : '#fff', maxWidth: '430px' }}
            >
              <div className="flex items-center gap-3 mb-4">
                <AlertCircle size={24} color="#FF5252" />
                <h3 style={{ color: mainText, fontSize: '16px', fontWeight: 700 }}>Delete Transaction?</h3>
              </div>
              <p style={{ color: subText, fontSize: '13px', marginBottom: '20px' }}>This action cannot be undone.</p>
              <div className="flex gap-3">
                <button
                  onClick={() => setDeleteConfirm(null)}
                  className="flex-1 py-3 rounded-xl"
                  style={{ background: isDark ? '#334155' : '#F1F5F9', color: subText, fontSize: '14px' }}
                >
                  Cancel
                </button>
                <button
                  onClick={() => { deleteTransaction(deleteConfirm); setDeleteConfirm(null); }}
                  className="flex-1 py-3 rounded-xl"
                  style={{ background: 'linear-gradient(135deg, #FF5252, #FF1744)', color: '#fff', fontSize: '14px', fontWeight: 600 }}
                >
                  Delete
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      <div style={{ height: '8px' }} />
    </div>
  );
}
