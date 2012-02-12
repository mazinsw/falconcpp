/*
 * This file is part of the Code::Blocks IDE and licensed under the GNU General Public License, version 3
 * http://www.gnu.org/licenses/gpl-3.0.html
 *
 * $Revision$
 * $Id$
 * $HeadURL$
 */

#include "asstreamiterator.h"

ASStreamIterator::ASStreamIterator(const char* in)
: m_In(in), m_PeekStart(0), m_curline(0)
{
	//ctor
}

ASStreamIterator::~ASStreamIterator()
{
	//dtor
}

bool ASStreamIterator::hasMoreLines() const
{
    return (*m_In) != 0;
}

inline bool ASStreamIterator::IsEOL(char ch)
{
    if (ch == '\r' || ch == '\n')
    {
        return true;
    }

    return false;
}

std::string ASStreamIterator::nextLine(bool emptyLineWasDeleted)
{
    return readLine();
}

std::string ASStreamIterator::readLine()
{
    m_buffer.clear();

    while (*m_In != 0)
    {
        if (!IsEOL(*m_In))
        {
            m_buffer.push_back(*m_In);
        }

        ++m_In;

        if (IsEOL(*m_In))
        {
            // if CRLF (two chars) peek next char (avoid duplicating empty-lines)
            if (*m_In != *(m_In + 1) && IsEOL(*(m_In + 1)))
            {
                ++m_In;
            }

            break;
        }
    }

    m_buffer.push_back(0);
    ++m_curline;

    return std::string(m_buffer.c_str());
}

std::string ASStreamIterator::peekNextLine()
{
    if (!m_PeekStart)
    {
        m_PeekStart = m_In;
    }

    return readLine();
}

void ASStreamIterator::peekReset()
{
    m_In = m_PeekStart;
    m_PeekStart = 0;
}
