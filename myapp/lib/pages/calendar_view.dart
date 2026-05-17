import { useState } from 'react';
import { useNavigate } from 'react-router';
import {
  ArrowLeft,
  ChevronLeft,
  ChevronRight,
  PlusCircle,
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { motion, AnimatePresence } from 'motion/react';

const fmt = (n: number) =>
  n > 0 ? `₹${(n / 1000).toFixed(1)}k` : '';

const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

const MONTHS_LIST = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

export function CalendarView() {
  const navigate = useNavigate();

  const { transactions, settings, getCategoryById } = useApp();

  // Dynamic current month
  const [currentDate, setCurrentDate] = useState(new Date());

  // No predefined selected day
  const [selectedDay, setSelectedDay] = useState<number | null>(null);

  const isDark = settings.darkMode;

  const cardBg = isDark
    ? 'rgba(30,41,59,0.9)'
    : '#FFFFFF';

  const mainText = isDark
    ? '#F8FAFC'
    : '#0F172A';

  const subText = isDark
    ? '#64748B'
    : '#9CA3AF';

  const borderColor = isDark
    ? 'rgba(255,255,255,0.06)'
    : 'rgba(0,0,0,0.06)';

  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();

  const monthStr = `${year}-${String(month + 1).padStart(2, '0')}`;

  const firstDay = new Date(year, month, 1).getDay();

  const daysInMonth = new Date(year, month + 1, 0).getDate();

  // Daily summary
  const dailySummary: Record<
    number,
    { income: number; expense: number }
  > = {};

  transactions.forEach(tx => {
    if (!tx.date.startsWith(monthStr)) return;

    const day = parseInt(tx.date.split('-')[2]);

    if (!dailySummary[day]) {
      dailySummary[day] = {
        income: 0,
        expense: 0,
      };
    }

    if (tx.type === 'income') {
      dailySummary[day].income += tx.amount;
    } else {
      dailySummary[day].expense += tx.amount;
    }
  });

  // Monthly totals
  const monthIncome = Object.values(dailySummary).reduce(
    (s, d) => s + d.income,
    0
  );

  const monthExpense = Object.values(dailySummary).reduce(
    (s, d) => s + d.expense,
    0
  );

  // Selected day transactions
  const selectedTxns =
    selectedDay !== null
      ? transactions.filter(
          tx =>
            tx.date ===
            `${monthStr}-${String(selectedDay).padStart(2, '0')}`
        )
      : [];

  const prevMonth = () => {
    setCurrentDate(new Date(year, month - 1, 1));
  };

  const nextMonth = () => {
    setCurrentDate(new Date(year, month + 1, 1));
  };

  const today = new Date();

  return (
    <div
      style={{
        background: isDark ? '#0F172A' : '#F8FAFC',
        minHeight: '100%',
        fontFamily: "'Poppins', sans-serif",
      }}
    >
      {/* Header */}
      <div className="flex items-center gap-3 px-5 pt-12 pb-4">
        <button
          onClick={() => navigate(-1)}
          className="flex items-center justify-center rounded-xl"
          style={{
            width: '40px',
            height: '40px',
            background: cardBg,
            border: `1px solid ${borderColor}`,
          }}
        >
          <ArrowLeft size={20} color={mainText} />
        </button>

        <h1
          style={{
            color: mainText,
            fontSize: '18px',
            fontWeight: 700,
            flex: 1,
          }}
        >
          Calendar
        </h1>

        <button
          onClick={() => navigate('/app/add-transaction')}
          className="flex items-center justify-center rounded-xl"
          style={{
            width: '40px',
            height: '40px',
            background: 'rgba(41,121,255,0.15)',
            border: '1px solid rgba(41,121,255,0.3)',
          }}
        >
          <PlusCircle size={20} color="#2979FF" />
        </button>
      </div>

      {/* Month Navigation */}
      <div className="px-5 mb-4">
        <div
          className="flex items-center justify-between p-4 rounded-2xl"
          style={{
            background: cardBg,
            border: `1px solid ${borderColor}`,
          }}
        >
          <button
            onClick={prevMonth}
            className="p-2 rounded-xl"
            style={{
              background: isDark
                ? 'rgba(255,255,255,0.05)'
                : '#F1F5F9',
            }}
          >
            <ChevronLeft size={20} color={mainText} />
          </button>

          <div className="text-center">
            <p
              style={{
                color: mainText,
                fontSize: '18px',
                fontWeight: 700,
              }}
            >
              {MONTHS_LIST[month]}
            </p>

            <p
              style={{
                color: subText,
                fontSize: '12px',
              }}
            >
              {year}
            </p>
          </div>

          <button
            onClick={nextMonth}
            className="p-2 rounded-xl"
            style={{
              background: isDark
                ? 'rgba(255,255,255,0.05)'
                : '#F1F5F9',
            }}
          >
            <ChevronRight size={20} color={mainText} />
          </button>
        </div>
      </div>

      {/* Monthly Summary */}
      <div className="px-5 mb-4 grid grid-cols-3 gap-3">
        {[
          {
            label: 'Income',
            value: monthIncome,
            color: '#00C853',
          },
          {
            label: 'Expenses',
            value: monthExpense,
            color: '#FF5252',
          },
          {
            label: 'Savings',
            value: monthIncome - monthExpense,
            color: '#2979FF',
          },
        ].map(item => (
          <div
            key={item.label}
            className="rounded-2xl p-3 text-center"
            style={{
              background: cardBg,
              border: `1px solid ${borderColor}`,
            }}
          >
            <p
              style={{
                color: item.color,
                fontSize: '13px',
                fontWeight: 700,
              }}
            >
              ₹{(item.value / 1000).toFixed(1)}k
            </p>

            <p
              style={{
                color: subText,
                fontSize: '10px',
              }}
            >
              {item.label}
            </p>
          </div>
        ))}
      </div>

      {/* Calendar */}
      <div className="px-5 mb-4">
        <div
          className="rounded-3xl overflow-hidden"
          style={{
            background: cardBg,
            border: `1px solid ${borderColor}`,
          }}
        >
          {/* Day Headers */}
          <div className="grid grid-cols-7 px-2 pt-3 pb-1">
            {DAYS.map(day => (
              <div
                key={day}
                className="text-center py-1"
                style={{
                  color: subText,
                  fontSize: '10px',
                  fontWeight: 600,
                }}
              >
                {day}
              </div>
            ))}
          </div>

          {/* Dates */}
          <div className="grid grid-cols-7 gap-0 px-2 pb-3">
            {Array.from({ length: firstDay }).map((_, i) => (
              <div key={`empty-${i}`} />
            ))}

            {Array.from({ length: daysInMonth }).map((_, i) => {
              const day = i + 1;

              const summary = dailySummary[day];

              const isSelected = selectedDay === day;

              const isToday =
                today.getFullYear() === year &&
                today.getMonth() === month &&
                today.getDate() === day;

              return (
                <button
                  key={day}
                  onClick={() =>
                    setSelectedDay(
                      selectedDay === day ? null : day
                    )
                  }
                  className="flex flex-col items-center rounded-xl py-1 px-0.5 transition-all"
                  style={{
                    background: isSelected
                      ? 'linear-gradient(135deg, rgba(41,121,255,0.2), rgba(41,121,255,0.1))'
                      : 'transparent',

                    border: isSelected
                      ? '1px solid rgba(41,121,255,0.4)'
                      : '1px solid transparent',

                    minHeight: '56px',
                  }}
                >
                  <span
                    className="rounded-full flex items-center justify-center"
                    style={{
                      width: '24px',
                      height: '24px',

                      background: isToday
                        ? '#2979FF'
                        : 'transparent',

                      color: isToday
                        ? '#fff'
                        : isSelected
                        ? '#2979FF'
                        : mainText,

                      fontSize: '12px',

                      fontWeight:
                        isToday || isSelected ? 700 : 400,
                    }}
                  >
                    {day}
                  </span>

                  {summary?.income > 0 && (
                    <span
                      style={{
                        color: '#00C853',
                        fontSize: '8px',
                        fontWeight: 600,
                        lineHeight: 1,
                      }}
                    >
                      {fmt(summary.income)}
                    </span>
                  )}

                  {summary?.expense > 0 && (
                    <span
                      style={{
                        color: '#FF5252',
                        fontSize: '8px',
                        fontWeight: 600,
                        lineHeight: 1,
                      }}
                    >
                      {fmt(summary.expense)}
                    </span>
                  )}
                </button>
              );
            })}
          </div>
        </div>
      </div>

      {/* Legend */}
      <div className="px-5 mb-4 flex items-center gap-4">
        {[
          {
            color: '#00C853',
            label: 'Income',
          },
          {
            color: '#FF5252',
            label: 'Expense',
          },
          {
            color: '#2979FF',
            label: 'Balance',
          },
        ].map(item => (
          <div
            key={item.label}
            className="flex items-center gap-1.5"
          >
            <div
              className="rounded-full"
              style={{
                width: '8px',
                height: '8px',
                background: item.color,
              }}
            />

            <span
              style={{
                color: subText,
                fontSize: '11px',
              }}
            >
              {item.label}
            </span>
          </div>
        ))}
      </div>

      {/* Selected Day Transactions */}
      <AnimatePresence>
        {selectedDay !== null && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 20 }}
            className="px-5"
          >
            <h3
              style={{
                color: mainText,
                fontSize: '15px',
                fontWeight: 600,
                marginBottom: '12px',
              }}
            >
              {MONTHS_LIST[month]} {selectedDay}, {year}
            </h3>

            {selectedTxns.length === 0 ? (
              <div
                className="flex flex-col items-center gap-3 py-8 rounded-3xl"
                style={{
                  background: cardBg,
                  border: `1px solid ${borderColor}`,
                }}
              >
                <span style={{ fontSize: '36px' }}>📅</span>

                <p
                  style={{
                    color: subText,
                    fontSize: '13px',
                  }}
                >
                  No transactions on this day
                </p>

                <button
                  onClick={() =>
                    navigate('/app/add-transaction')
                  }
                  className="flex items-center gap-2 px-4 py-2 rounded-xl"
                  style={{
                    background:
                      'rgba(41,121,255,0.15)',
                    border:
                      '1px solid rgba(41,121,255,0.3)',
                  }}
                >
                  <PlusCircle
                    size={14}
                    color="#2979FF"
                  />

                  <span
                    style={{
                      color: '#2979FF',
                      fontSize: '12px',
                      fontWeight: 600,
                    }}
                  >
                    Add Transaction
                  </span>
                </button>
              </div>
            ) : (
              <div className="flex flex-col gap-2">
                {selectedTxns.map(tx => {
                  const cat = getCategoryById(tx.category);

                  return (
                    <div
                      key={tx.id}
                      className="flex items-center gap-3 p-3 rounded-2xl"
                      style={{
                        background: cardBg,
                        border: `1px solid ${borderColor}`,
                      }}
                    >
                      <div
                        className="flex items-center justify-center rounded-xl text-lg"
                        style={{
                          width: '40px',
                          height: '40px',
                          background: `${cat?.color || '#888'}18`,
                          flexShrink: 0,
                        }}
                      >
                        {cat?.icon || '💰'}
                      </div>

                      <div className="flex-1">
                        <p
                          style={{
                            color: mainText,
                            fontSize: '13px',
                            fontWeight: 600,
                          }}
                        >
                          {tx.title}
                        </p>

                        <p
                          style={{
                            color: subText,
                            fontSize: '11px',
                          }}
                        >
                          {cat?.name} • {tx.time}
                        </p>
                      </div>

                      <span
                        style={{
                          color:
                            tx.type === 'income'
                              ? '#00C853'
                              : '#FF5252',

                          fontSize: '14px',
                          fontWeight: 700,
                        }}
                      >
                        {tx.type === 'income'
                          ? '+'
                          : '-'}
                        ₹
                        {tx.amount.toLocaleString(
                          'en-IN'
                        )}
                      </span>
                    </div>
                  );
                })}
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>

      <div style={{ height: '16px' }} />
    </div>
  );
}